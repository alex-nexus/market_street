require "spec_helper"

describe Admin::Fulfillment::ReturnAuthorizationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/fulfillment/orders/11/return_authorizations" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "index", :order_id => '11')
    end

    it "recognizes and generates #new" do
      { :get => "/admin/fulfillment/orders/11/return_authorizations/new" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "new", :order_id => '11')
    end

    it "recognizes and generates #show" do
      { :get => "/admin/fulfillment/orders/11/return_authorizations/1" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "show", :id => "1", :order_id => '11')
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/fulfillment/orders/11/return_authorizations/1/edit" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "edit", :id => "1", :order_id => '11')
    end

    it "recognizes and generates #create" do
      { :post => "/admin/fulfillment/orders/11/return_authorizations" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "create", :order_id => '11')
    end

    it "recognizes and generates #update" do
      { :put => "/admin/fulfillment/orders/11/return_authorizations/1" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "update", :id => "1", :order_id => '11')
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/fulfillment/orders/11/return_authorizations/1" }.should route_to(:controller => "admin/fulfillment/return_authorizations", :action => "destroy", :id => "1", :order_id => '11')
    end

  end
end
