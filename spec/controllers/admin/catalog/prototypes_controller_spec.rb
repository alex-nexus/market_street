require 'spec_helper'

describe Admin::Catalog::PrototypesController do
  render_views

  before(:each) do
    activate_authlogic

    @user = create_admin_user
    login_as(@user)
  end

  it "index action renders index template" do
    @prototype = create(:prototype)
    get :index
    expect(response).to render_template(:index)
  end

  it "new action renders new template" do
    Property.stubs(:all).returns([])
    get :new
    expect(response).to redirect_to(new_admin_catalog_property_url)
  end

  it "new action renders new template" do
    @property = create(:property)
    get :new
    expect(response).to render_template(:new)
  end

  it "create action renders new template when model is invalid" do
    Prototype.any_instance.stubs(:valid?).returns(false)
    post :create, :prototype => {:name => 'Tes', :property_ids => []}
    expect(response).to render_template(:new)
  end

  it "create action redirects when model is valid" do
    Prototype.any_instance.stubs(:valid?).returns(true)
    post :create, :prototype => {:name => 'fred'}
    expect(response).to redirect_to(admin_catalog_prototypes_url())
  end

  it "edit action renders edit template" do
    @prototype = create(:prototype)
    get :edit, :id => @prototype.id
    expect(response).to render_template(:edit)
  end

  it "update action renders edit template when model is invalid" do
    @prototype = create(:prototype)
    Prototype.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @prototype.id, :prototype => {:name => 'Tes', :property_ids => []}
    expect(response).to render_template(:edit)
  end
# ( :name, :active, :property_ids )
  it "update action redirects when model is valid" do
    property = create(:property)
    @prototype = create(:prototype)
    Prototype.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @prototype.id, :prototype => {:name => 'Tes', :property_ids => [property.id]}
    @prototype.reload
    @prototype.property_ids.include?(property.id).should be_true
    expect(response).to redirect_to(admin_catalog_prototypes_url())
  end

  it "destroy action should destroy model and redirect to index action" do
    @prototype = create(:prototype)
    delete :destroy, :id => @prototype.id
    expect(response).to redirect_to(admin_catalog_prototypes_url)
    Prototype.find(@prototype.id).active.should be_false
  end
end
