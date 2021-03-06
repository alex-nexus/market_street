require 'spec_helper'

describe Admin::Offer::SalesController do
  render_views
  
  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action renders index template" do
    sale = FactoryGirl.create(:sale)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action renders show template" do
    sale = FactoryGirl.create(:sale)
    get :show, :id => sale.id
    expect(response).to render_template(:show)
  end

  it "new action renders new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action renders new template when model is invalid" do
    sale = FactoryGirl.build(:sale)
    Sale.any_instance.stubs(:valid?).returns(false)
    post :create, :sale => sale.attributes.except('id', 'created_at', 'updated_at')
    expect(response).to render_template(:new)
  end

  it "create action redirects when model is valid" do
    sale = FactoryGirl.build(:sale)
    Sale.any_instance.stubs(:valid?).returns(true)
    post :create, :sale => sale.attributes.except('id', 'created_at', 'updated_at')
    expect(response).to redirect_to(admin_offer_sale_url(assigns[:sale]))
  end

  it "edit action renders edit template" do
    sale = FactoryGirl.create(:sale)
    get :edit, :id => sale.id
    expect(response).to render_template(:edit)
  end

  it "update action renders edit template when model is invalid" do
    sale = FactoryGirl.create(:sale)
    Sale.any_instance.stubs(:valid?).returns(false)
    put :update, :id => sale.id, :sale => sale.attributes.except('id', 'created_at', 'updated_at')
    expect(response).to render_template(:edit)
  end

  it "update action redirects when model is valid" do
    sale = FactoryGirl.create(:sale)
    Sale.any_instance.stubs(:valid?).returns(true)
    put :update, :id => sale.id, :sale => sale.attributes.except('id', 'created_at', 'updated_at')
    expect(response).to redirect_to(admin_offer_sale_url(assigns[:sale]))
  end

  it "destroy action should destroy model and redirect to index action" do
    sale = FactoryGirl.create(:sale)
    delete :destroy, :id => sale.id
    expect(response).to redirect_to(admin_offer_sales_url)
    Sale.exists?(sale.id).should be_false
  end
end
