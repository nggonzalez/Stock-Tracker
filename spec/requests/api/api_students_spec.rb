require 'rails_helper'

RSpec.describe "Api::Students", :type => :request do
  describe "GET /api_students" do
    it "works! (now write some real specs)" do
      get api_students_path
      expect(response).to have_http_status(200)
    end
  end
end
