# frozen_string_literal: true

class FetchLatLangJob < ApplicationJob
  queue_as :default

  def perform
    tweets = Tweet.where(location_fetched: false)
    Rails.logger.info("Fetching location for #{tweets.count} tweets")
    tweets.each do |tweet|
      restore_at = tweet.restore_at
      if tweet.affected_areas.blank?
        tweet.update(location_fetched: true)
        next
      end
      locations = LocationParser.parse(affected_areas: tweet.affected_areas)
      Rails.logger.info('Location Parser Result '\
                        + { affected_areas: tweet.affected_areas,
                            locations: locations }.to_json)
      locations.each do |address|
        next if address.blank?

        location = Location.find_or_initialize_by(address: address)
        location.restore_at = restore_at
        tweet.location_fetched = true
        ActiveRecord::Base.transaction do
          tweet.save!
          location.save!
        end
      end
    end
  end
end
