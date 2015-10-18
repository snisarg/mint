class TwitterApiController < ApplicationController
  def fetch_tweets
  	twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_KEY_SECRET']
      config.access_token = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    twitter_client.search("XFactor -rt", result_type: "recent").take(3).each do |tweet|
      @message = tweet.text
    end

    # puts twitter_client.trends(id=1, options = {}).location()

    # TweetStream::Client.new.track('topic') do |status|
    #   puts "#{status.text}"
    # end

  end
end
