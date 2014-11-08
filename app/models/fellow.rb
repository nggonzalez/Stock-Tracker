class Fellow < ActiveRecord::Base
  has_many :mentors
  has_many :teams, :through => :mentors
end
