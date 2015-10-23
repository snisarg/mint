class TwitterApiController < ApplicationController

  #setter
  def search_keyword=(search_keyword)
    @search_keyword = search_keyword
  end

  #getter
  def search_keyword
    @search_keyword
  end

  #getter
  def tweet_received_text
    @tweet_received_text
  end

  def fetch_tweets(hashtag)
  	twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_KEY_SECRET']
      config.access_token = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    return twitter_client.search(hashtag, result_type: "recent", geo_enabled: "true").take(5)

    #.each do |tweet_received|
      # @message = tweet_received.text
      #@tweet_received_text = tweet_received.text
      # puts tweet_received
    #end

    # puts twitter_client.trends(id=1, options = {}).location()

    # TweetStream::Client.new.track('topic') do |status|
    #   puts "#{status.text}"
    # end

  end
end
