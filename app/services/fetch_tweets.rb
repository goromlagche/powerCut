# frozen_string_literal: true

class FetchTweets
  BESCOM_HANDLE = 'NammaBESCOM'

  def run
    tweets = fetch
    # recurse only once
    tweets.concat(fetch) if need_another_fetch?(tweets: tweets)
    tweets
  end

  private

  def need_another_fetch?(tweets:)
    last_tweet_url = TweetData.last&.url
    tweets.select { |tweet| tweet.url.to_s == last_tweet_url }.blank?
  end

  def fetch
    Rails.logger.info('Fetching tweets')
    TweetApi
      .new
      .client.user_timeline(BESCOM_HANDLE, count: 20)
      .reject(&:reply?)
      .select(&:media?)
  end
end
