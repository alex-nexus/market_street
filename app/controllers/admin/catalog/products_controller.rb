class Admin::Catalog::ProductsController < Admin::BaseController
  add_breadcrumb "Products", :admin_catalog_products_path
  helper_method :product_types
  respond_to :html, :json
  authorize_resource

  def index
    @q = Product.search(params[:q])
    @products = @q.result.order(sort_column + " " + sort_direction).
                  page(pagination_page).per(pagination_rows)
  end

  def show
    @product = Product.find(params[:id])
    respond_with(@product)
  end

  def new
    form_info
    if @prototypes.empty?
      flash[:notice] = "You must create a prototype before you create a product."
      redirect_to new_admin_catalog_prototype_url
    else
      @product            = Product.new
      @product.prototype  = Prototype.new
    end
  end

  def create
    @product = Product.new(allowed_params)

    if @product.save
      flash[:notice] = "Success, You should create a variant for the product."
      redirect_to edit_admin_catalog_products_description_url(@product)
    else
      form_info
      flash[:error] = "The product could not be saved"
      render :action => :new
    end
  rescue
    render :text => "Please make sure you have solr started... Run this in the command line => bundle exec rake sunspot:solr:start"
  end

  def edit
    @product = Product.includes(:properties,:product_properties, {:prototype => :properties}).find(params[:id])
    form_info
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(allowed_params)
      redirect_to admin_catalog_product_url(@product)
    else
      form_info
      render :action => :edit
    end
  end

  def add_properties
    prototype  = Prototype.includes(:properties).find(params[:id])
    @properties = prototype.properties
    all_properties = Property.all

    @properties_hash = all_properties.inject({:active => [], :inactive => []}) do |h, property|
      if  @properties.detect{|p| (p.id == property.id) }
        h[:active] << property.id
      else
        h[:inactive] << property.id
      end
      h
    end
    respond_to do |format|
      format.html
      format.json { render :json => @properties_hash.to_json }
    end
  end

  def activate
    @product = Product.find(params[:id])
    @product.deleted_at = nil
    if @product.save
      redirect_to admin_catalog_product_url(@product)
    else
      flash[:alert] = "Please add a description before Activating."
      redirect_to edit_admin_catalog_products_description_url(@product)
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.deleted_at ||= Time.zone.now
    @product.save

    redirect_to admin_catalog_product_url(@product)
  end

  def default_sort_column
    "products.name"
  end  

  private

  def allowed_params
    params.require(:product).permit(:name, :description, :product_keywords, :set_keywords, :product_type_id,
      :prototype_id, :permalink, :available_at, :deleted_at,
      :meta_keywords, :meta_description, :featured, :description_markup,
      product_properties_attributes: [:product_id, :property_id, :position, :description])
  end

  def form_info
    @prototypes               = Prototype.all.collect{|pt| [pt.name, pt.id]}
    @all_properties           = Property.all    
  end

  def product_types
    @product_types ||= ProductType.all
  end
end