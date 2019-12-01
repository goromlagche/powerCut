# frozen_string_literal: true

class FetchTweets
  BESCOM_HANDLE = 'NammaBESCOM'

  def run
    @count = 20
    tweets = fetch
    if need_another_fetch?(tweets: tweets)
      @count *= 2
      tweets.concat(fetch)
    end
    tweets
  end

  def need_another_fetch?(tweets:)
    last_tweet_url = Tweet.last&.url
    tweets.select { |tweet| tweet.url.to_s == last_tweet_url }.blank?
  end

  def fetch
    Rails.logger.info('Fetching tweets')
    TweetApi
      .new
      .client.user_timeline(BESCOM_HANDLE, count: @count)
      .reject(&:reply?)
      .select(&:media?)
  end
end
