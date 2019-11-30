class TweetApi
  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = Rails.application.credentials.dig(:twitter, :api_key)
      config.consumer_secret = Rails.application.credentials.dig(:twitter, :secret_key)
    end
  end
end
