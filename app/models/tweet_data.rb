class TweetData < ApplicationRecord
  has_many :locations
  validates :url, uniqueness: { case_sensitive: true }, presence: true
end
