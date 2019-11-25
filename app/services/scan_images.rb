# frozen_string_literal: true

class ScanImages
  require 'open-uri'
  BESCOM_URL = 'https://twitter.com/i/profiles/show/NammaBESCOM/media_timeline'

  XPATH = "//li[@id[starts-with(., 'stream-item-tweet')]]//"\
          "div[@class='AdaptiveMediaOuterContainer']//img"

  def run
    @tweet_data = []
    begin
      images.each do |image|
        @image_id = image.path.split('/')[-1]
        next if TweetData.find_by(image_id: @image_id)

        @tmp_file = Tempfile.new(@image_id)
        IO.copy_stream(image.open, @tmp_file.path)
        parse_and_set
        @tmp_file&.close
      end
      TweetData.insert_all!(@tweet_data)
    ensure
      File.unlink(@tmp_file) if @tmp_file
    end
  end

  private

  def parse_and_set
    raw_data = RTesseract.new(@tmp_file.path).to_s
    parser = BescomTweetParser.new
    parsed_data = parser.parse(raw_data)
    locations = ugly_location_parser(locations: parsed_data[:affected_area])
    @tweet_data << { image_id: @image_id,
                     raw_data: raw_data,
                     restore_at: Time.zone.parse(parsed_data[:restore_at]),
                     affected_areas: locations,
                     created_at: Time.zone.now,
                     updated_at: Time.zone.now }

    Rails.logger.info "parsed string => #{parsed_data[:affected_area]}"
    Rails.logger.info "regexed string => #{locations}"
  rescue Parslet::ParseFailed => e
    Rails.logger.info "Parsing failed => \n string"\
                      " => #{raw_data} \n msg => #{e.message}"
  end

  def images
    return @images if defined? @images

    body = Net::HTTP.get(URI(BESCOM_URL))
    html_page = JSON.parse(body)['items_html'].strip.chomp.gsub("\n", '')
    images = Nokogiri::HTML(html_page).xpath(XPATH)
    @images = images.map { |image| URI.parse(image['src']) }
  end

  def ugly_location_parser(locations:)
    data = locations
           .to_s
           .scan(/([a-z]|[A-Z]|[0-9]|,| |\.)/).join # accept only certain chars
           .gsub(/\s+/, ' ') # combine all whitespaces into one

    data = if data.scan(/.*Surrounding/).present?
             data.scan(/.*Surrounding/).join.gsub(/Surrounding/, ' ') # remove Surrounding
           elsif data.scan(/.*surrounding/).present?
             data.scan(/.*surrounding/).join.gsub(/surrounding/, ' ') # remove Surrounding
           else
             data
           end
    data
      .gsub(/ and /, ',') # replace and with comma
      .gsub(/ And /, ',') # replace And with comma
      .gsub(/\./, ',') # replace dot with comma
      .gsub(/part of/, ',') # maker part, full
      .gsub(/Part of/, ',') # maker Part, full
      .gsub(/ LO/, ' Layout') # maker Part, full
      .gsub(/ lo/, ' Layout') # maker Part, full
      .strip.split(',').map(&:strip).join(',')
  end
end
