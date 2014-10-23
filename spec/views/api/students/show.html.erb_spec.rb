require 'rails_helper'

RSpec.describe "api/students/show", :type => :view do
  before(:each) do
    @api_student = assign(:api_student, Api::Student.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
