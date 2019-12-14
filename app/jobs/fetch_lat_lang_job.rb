# frozen_string_literal: true

class FetchLatLangJob < ApplicationJob
  queue_as :location

  def perform(tweet:)
    return if tweet.affected_areas.blank?

    restore_at = tweet.restore_at
    locations = LocationParser.parse(affected_areas: tweet.affected_areas)
    Rails.logger.info('Location Parser Result '\
                      + { affected_areas: tweet.affected_areas,
                          locations: locations }.to_json)
    locations.each do |address|
      next if address.blank?

      location = Location.find_or_initialize_by(address: address)
      location.restore_at = restore_at
      ActiveRecord::Base.transaction do
        tweet.save!
        location.save!
      end
    end
  end
end
