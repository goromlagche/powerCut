# frozen_string_literal: true

require 'rails_helper'

describe ScanImages do
  it 'fetches tweets' do
    VCR.turn_on!
    VCR.use_cassette('fetch_tweets') do
      described_class.new.run
      expect(Tweet.count).to eq 7
    end
    VCR.use_cassette('fetch_tweets_again') do
      described_class.new.run
      expect(Tweet.count).to eq 7
    end
    VCR.use_cassette('get_lat_lang') do
      FetchLatLangJob.perform_now
      expect(Location.count).to eq 20
    end
    FetchLatLangJob.perform_now
    expect(Location.count).to eq 20
  end
end
