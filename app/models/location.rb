class Location < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  validates :address,
            uniqueness: { case_sensitive: false },
            presence: true

  def self.lat_lng
    where.not(latitude: nil).where.not(longitude: nil)
  end

  def full_address
    [address, 'Bengaluru', 'Karnataka', 'India'].compact.join(', ')
  end

  # living life on the edge
  def as_json(*)
    super.slice('id', 'latitude', 'longitude', 'restore_at', 'address').tap do |hash|
      hash['restore_at'] = Time.zone.parse(hash['restore_at']).to_formatted_s(:short)
    end
  end
end
