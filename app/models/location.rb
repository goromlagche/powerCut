class Location < ApplicationRecord
  validates :address,
            uniqueness: { case_sensitive: false },
            presence: true

  def full_address
    [address, 'Bengaluru', 'Karnataka', 'India'].compact.join(', ')
  end
end
