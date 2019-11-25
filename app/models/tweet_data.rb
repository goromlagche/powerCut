class TweetData < ApplicationRecord
  has_many :locations
  validates :image_id, uniqueness: { case_sensitive: true }, presence: true
end
