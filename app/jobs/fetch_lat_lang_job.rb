# frozen_string_literal: true

class FetchLatLangJob < ApplicationJob
  queue_as :default

  def perform
    tweets = TweetData
             .includes(:locations)
             .where(locations: { tweet_data_id: nil })
    tweets.each do |tweet|
      restore_at = tweet.restore_at
      tweet.affected_areas.split(',').each do |address|
        location = tweet.locations.find_or_initialize_by(address: address)
        location.restore_at = restore_at

        if location.id.present?
          location.save!
          next
        end

        location.geo_json = JSON.parse(
          Net::HTTP.get(URI('https://nominatim.openstreetmap.org/'\
                            "search?q=#{address},Bengaluru,Karnataka,India"\
                            '&polygon_geojson=1&format=geojson'))
        )

        if location.geo_json['features'].blank?
          Rails.logger.info "Unable to get geocode => #{address}"
          next
        end

        location.geo_json['features'] = [location.geo_json['features'].first]

        location.save!
      end
    end
  end
end
