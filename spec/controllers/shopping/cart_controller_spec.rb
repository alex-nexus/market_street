require 'spec_helper'

describe Shopping::CartController do
  render_views

  before(:each) do
    activate_authlogic
    @user = create(:user)
    login_as(@user)

    @variant = create(:variant)
    create_cart(@user, [@variant])        

    @cart = Cart.where(:user_id => @user.id).first
    @cart_item = @cart.cart_items.first
  end

  it "index action renders index template" do
    get :current
    expect(response).to render_template(:current)
  end

  #todo add test for create

  context "when update" do 
    let(:cart_items_attributes) { {"0"=>{"quantity"=> @cart_item.quantity+1, "id"=>@cart_item.id}} }        
    it "updates cart item quantity and refreshes" do 
      put :update, :id => @cart.id, "commit"=>"Update", 
        "cart_item" => cart_items_attributes
      expect(response).to redirect_to shopping_cart_path
    end
  end

  context "when checkout" do 
    let(:cart_items_attributes) { {"0"=>{"id"=>@cart_item.id}} }        
    it "redirects to checkout page" do 
      put :update, :id => @cart.id, :commit => 'Checkout', 
        "cart_item" => cart_items_attributes 
      expect(response).to redirect_to checkout_shopping_order_url('checkout')      
    end
  end

  it "destroy action renders index template" do
    delete :destroy, :id => @variant.id
    expect(CartItem.where(variant_id: @variant.id).first).not_to be_active
    expect(response).to redirect_to shopping_cart_path
  end
end