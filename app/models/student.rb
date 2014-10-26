class Student < ActiveRecord::Base
  has_many :offers
  # has_many :teams, through: :offers
  has_many :employees
  has_many :teams, through: :employees
end
