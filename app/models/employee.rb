class Employee < ActiveRecord::Base
  belongs_to :student
  belongs_to :team
end
