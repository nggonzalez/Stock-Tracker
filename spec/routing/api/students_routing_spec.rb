require "rails_helper"

RSpec.describe Api::StudentsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/students").to route_to("api/students#index")
    end

    it "routes to #new" do
      expect(:get => "/api/students/new").to route_to("api/students#new")
    end

    it "routes to #show" do
      expect(:get => "/api/students/1").to route_to("api/students#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api/students/1/edit").to route_to("api/students#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/students").to route_to("api/students#create")
    end

    it "routes to #update" do
      expect(:put => "/api/students/1").to route_to("api/students#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/students/1").to route_to("api/students#destroy", :id => "1")
    end

  end
end
