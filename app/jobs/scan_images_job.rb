# frozen_string_literal: true

class ScanImagesJob < ApplicationJob
  require 'open-uri'
  queue_as :scan_images

  def perform(tweets:)
    JSON.parse(tweets).each do |tweet|
      @url = tweet['url']
      @tweeted_at = Time.zone.parse(tweet['created_at'])
      next if Tweet.find_by(url: @url.to_s)

      @tmp_file = Tempfile.new(@url)
      image_url = tweet['image_url']
      Rails.logger.info("Fetching image => #{image_url}")
      IO.copy_stream(open(image_url), @tmp_file.path)
      parse_and_set
      @tmp_file&.close
      sleep 1
    end
  ensure
    File.unlink(@tmp_file) if @tmp_file
  end

  private

  def parse_and_set
    raw_data = RTesseract.new(@tmp_file.path).to_s
    Rails.logger.info("raw_text: #{raw_data}")
    tweet = Tweet.create(url: @url, raw_data: raw_data)
    parsed_data = BescomTweetParser.new.parse(raw_data)

    if parsed_data[:restore_at].present?
      handle_restore_at(tweet: tweet,
                        restore_at: parsed_data[:restore_at])
    end

    ActiveRecord::Base.record_timestamps = false
    tweet
      .update(affected_areas: parsed_data[:affected_area].to_s.strip,
              created_at: @tweeted_at, updated_at: Time.zone.now)
    ActiveRecord::Base.record_timestamps = true

    FetchLatLangJob.perform_later(tweet: tweet) if
      parsed_data[:affected_area].present?
  rescue Parslet::ParseFailed => e
    Rails.logger.error "Parsing failed => #{raw_data}"
    Rails.logger.error "Exception #{e.message}"
  end

  def handle_restore_at(tweet:, restore_at:)
    tweet.restore_at = Time.zone.parse(restore_at.to_s, @tweeted_at.to_date)
    tweet.restore_at += 1.day if (@tweeted_at - tweet.restore_at) > 2.hours
  rescue ArgumentError => e
    Rails.logger.error "Exception #{e.message}"
  end
end
