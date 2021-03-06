require 'spec_helper'

describe Admin::Inventory::SuppliersController do
  render_views

  before(:each) do
    activate_authlogic

    @user = create_admin_user
    login_as(@user)
  end


  it "index action renders index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "show action renders show template" do
    @supplier = create(:supplier)
    get :show, :id => @supplier.id
    expect(response).to render_template(:show)
  end

  it "new action renders new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action renders new template when model is invalid" do
    Supplier.any_instance.stubs(:valid?).returns(false)
    post :create, :supplier => {:name => 'John'}
    expect(response).to render_template(:new)
  end

  it "create action redirects when model is valid" do
    Supplier.any_instance.stubs(:valid?).returns(true)
    post :create, :supplier => {:name => 'Nike', :email => 'test@test.com'}
    expect(response).to redirect_to(admin_inventory_suppliers_url())
  end

  it "edit action renders edit template" do
    @supplier = create(:supplier)
    get :edit, :id => @supplier.id
    expect(response).to render_template(:edit)
  end

  it "update action renders edit template when model is invalid" do
    @supplier = create(:supplier)
    Supplier.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @supplier.id, :supplier => {:name => 'John', :email => 'test@test.com'}
    expect(response).to render_template(:edit)
  end

  it "update action redirects when model is valid" do
    @supplier = create(:supplier)
    Supplier.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @supplier.id, :supplier => {:name => 'John', :email => 'test@test.com'}
    expect(response).to redirect_to(admin_inventory_suppliers_url())
  end

end
