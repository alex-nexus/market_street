require 'spec_helper'

describe Customer::RegistrationsController do
  describe "#new" do 
    it "renders" do 
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    context "when signup succeeds" do
      let(:user) { build(:user) }
      it "displays a message with login success and redirect to root_url" do
        #UserMailer.expects(:signup_notification).once.returns(sign_up_mock)
        post :create, :user => {:password => user.password, 
                                :password_confirmation => user.password_confirmation, 
                                :first_name => user.first_name, 
                                :last_name => user.last_name, 
                                :email => user.email}
        expect(response).to redirect_to root_url
      end
    end

    context "when signup fails" do
      let(:user) { build(:user) }
      it "displays a message with login failure and render the sign up template" do
        post :create, :user => {:password => user.password, 
                                :password_confirmation => 'wrong password', 
                                :first_name => user.first_name, 
                                :last_name => user.last_name, 
                                :email => user.email}
        expect(response).to redirect_to new_customer_registration_url
      end
    end
  end  

  describe "activate" do
    render_views
    let(:user) { create(:user, :state => 'inactive') }
    
    it "show action renders show template" do
      get :activate, :id => user.id, :a => user.perishable_token
      expect(assigns[:user].id).to eq user.id
      expect(response).to redirect_to(root_url)
    end

    it "show action renders show template" do
      get :activate, :id => user.id, :a => 'bad0perishabletoken'
      expect(assigns[:user]).to be_nil
      expect(response).to redirect_to(root_url)
    end
  end
end