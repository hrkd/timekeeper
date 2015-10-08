class Task < ActiveRecord::Base
  has_many :works, dependent: :destroy
  belongs_to :user
end
