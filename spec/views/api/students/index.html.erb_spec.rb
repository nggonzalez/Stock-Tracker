require 'rails_helper'

RSpec.describe "api/students/index", :type => :view do
  before(:each) do
    assign(:api_students, [
      Api::Student.create!(),
      Api::Student.create!()
    ])
  end

  it "renders a list of api/students" do
    render
  end
end
