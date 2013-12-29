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
        expect(EmailWorker::SendSignUpNotification).to receive(:perform_async)
        post :create, :user => {:password => user.password, 
                                :password_confirmation => user.password_confirmation, 
                                :first_name => user.first_name, 
                                :last_name => user.last_name, 
                                :email => user.email}
        expect(flash[:alert]).to match(/Your account has been created/)
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
        expect(flash[:alert]).to match(/There is an error/)
        expect(response).to redirect_to new_customer_registration_url
      end
    end
  end  
end