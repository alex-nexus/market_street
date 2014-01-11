require 'spec_helper'

describe Shopping::BillingAddressesController do
  render_views

  let(:user) { create(:user) }
  let(:variant) { create(:variant) }
  let(:bill_address) { create(:bill_address, :addressable_id => user.id, :addressable_type => 'User') }
  
  before(:each) do
    activate_authlogic
    login_as(user)
    create_cart(user, [variant])    
  end

  it "index action renders index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "create action redirects when model is valid" do
    Address.any_instance.stubs(:valid?).returns(true)
    controller.stubs(:next_form_url).returns(shopping_orders_path)
    post :create, :address => bill_address.attributes
    expect(response).to redirect_to(shopping_orders_path)
  end

  it "edit action renders edit template" do
    get :edit, :id => bill_address.id
    expect(response).to render_template(:edit)
  end

  it "update action redirects when model is valid" do
    Address.any_instance.stubs(:valid?).returns(true)
    controller.stubs(:next_form_url).returns(shopping_orders_path)
    put :update, :id => bill_address.id, :address => bill_address.attributes
    expect(response).to redirect_to(shopping_orders_path)
  end

  it "update action redirects when model is valid" do
    Address.any_instance.stubs(:valid?).returns(true)
    controller.stubs(:next_form_url).returns(shopping_orders_path)
    put :select_address, :id => bill_address.id
    expect(response).to redirect_to(shopping_orders_path)
  end

  context "invalid address" do 
    it "redirects to index template" do
      bill_address.id = nil
      post :create, :address => bill_address.attributes
      expect(response).to render_template(:index)
    end
    it "redirects to edit template" do
      bill_address.first_name = nil #invalidate the address
      put :update, :id => bill_address.id, :address => bill_address.attributes
      expect(response).to render_template(:edit)
    end
  end
end