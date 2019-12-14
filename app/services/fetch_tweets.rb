# frozen_string_literal: true

class FetchTweets
  BESCOM_HANDLE = 'NammaBESCOM'

  def run
    @tweet_count = 20
    @page_count = 1
    @last_tweet_url = Tweet.last&.url
    @tweets = fetch

    20.times do
      break unless need_another_fetch?

      sleep 1
      @page_count += 1
      @tweets.concat(fetch)
    end
    @tweets
  end

  private

  def need_another_fetch?
    @tweets.select { |tweet| tweet.url.to_s == @last_tweet_url }.blank?
  end

  def fetch
    Rails.logger.info("Fetching tweets page => #{@page_count}")
    TweetApi
      .new
      .client
      .user_timeline(BESCOM_HANDLE, page: @page_count, count: @tweet_count)
      .reject(&:reply?)
      .select(&:media?)
  end
end
