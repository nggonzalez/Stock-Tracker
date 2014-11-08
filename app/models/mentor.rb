class Mentor < ActiveRecord::Base
  belongs_to :team
  belongs_to :fellow
end
