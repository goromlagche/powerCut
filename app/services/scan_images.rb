# frozen_string_literal: true

class ScanImages
  require 'open-uri'

  def run
    @tweet = []
    begin
      FetchTweets.new.run.each do |tweet|
        @url = tweet.url
        next if Tweet.find_by(url: @url.to_s)

        @tmp_file = Tempfile.new(@url)
        image_url = tweet.media.first.media_url
        Rails.logger.info("Fetching image => #{image_url}")
        IO.copy_stream(open(image_url), @tmp_file.path)
        parse_and_set
        @tmp_file&.close
      end
      Tweet.insert_all(@tweet) if @tweet.present?
    ensure
      File.unlink(@tmp_file) if @tmp_file
    end
  end

  private

  def parse_and_set
    raw_data = RTesseract.new(@tmp_file.path).to_s
    Rails.logger.info("raw_text: #{raw_data}")
    tweet = Tweet.create(url: @url, raw_data: raw_data)
    parsed_data = BescomTweetParser.new.parse(raw_data)

    tweet
      .update(restore_at: Time.zone.parse(parsed_data[:restore_at]),
              affected_areas: parsed_data[:affected_area].to_s.strip,
              created_at: Time.zone.now, updated_at: Time.zone.now)
  rescue Parslet::ParseFailed => e
    Rails.logger.error "Parsing failed => #{raw_data}"
    Rails.logger.error "Exception #{e.message}"
  end
end
