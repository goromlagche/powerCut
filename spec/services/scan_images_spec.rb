require 'rails_helper'

describe ScanImages do
  it 'fetches tweets' do
    VCR.turn_on!
    VCR.use_cassette('fetch_tweets') do
      described_class.new.run
      expect(TweetData.count).to eq 20
    end

    VCR.use_cassette('get_lat_lang') do
      FetchLatLangJob.perform_now
    end
  end
end
