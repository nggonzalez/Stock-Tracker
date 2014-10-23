require 'rails_helper'

RSpec.describe "api/students/edit", :type => :view do
  before(:each) do
    @api_student = assign(:api_student, Api::Student.create!())
  end

  it "renders the edit api_student form" do
    render

    assert_select "form[action=?][method=?]", api_student_path(@api_student), "post" do
    end
  end
end
