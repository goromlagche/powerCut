# frozen_string_literal: true

class FetchTweetsJob < ApplicationJob
  queue_as :fetch_tweets

  def perform
    all_tweets = FetchTweets.new.run
    all_tweets.each_slice(4) do |tweets|
      ScanImagesJob.perform_later(tweets: tweet_data(tweets: tweets))
    end
  end

  private

  def tweet_data(tweets:)
    tweets.map do |tweet|
      { url: tweet.url.to_s,
        image_url: tweet.media.first.media_url.to_s,
        created_at: tweet.created_at }
    end.to_json
  end
end
