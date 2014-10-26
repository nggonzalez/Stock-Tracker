class Team < ActiveRecord::Base
  has_many :offers
  # has_many :students, through: :offers
  has_many :employees
  has_many :students, :through => :employees
end
