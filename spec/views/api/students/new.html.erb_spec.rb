require 'rails_helper'

RSpec.describe "api/students/new", :type => :view do
  before(:each) do
    assign(:api_student, Api::Student.new())
  end

  it "renders new api_student form" do
    render

    assert_select "form[action=?][method=?]", api_students_path, "post" do
    end
  end
end
