require 'tweetstream'
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

  def fetch_tweets
    TweetStream.configure do |config|
      config.consumer_key = '0dsFEadLRBYjDSdi6aF8mNSzK'
      config.consumer_secret = 'wniHgxRLXA44qC8QYQ3K9pPBXElnGJrjPAlyJYC3Xi5jKs0EHx'
      config.oauth_token = '3875855958-v22Y5C0PT73JKDrv9LP2x1v8G09rLiuUpRAPQsb'
      config.oauth_token_secret = 'j7Tn6CmPMhBRLiUfByVWWg604HShgaTpOTkfJQ9eHsCxv'
      config.auth_method        = :oauth
    end

    TweetStream::Client.new.locations(-124.4096, 32.5343, -114.1308, 42.0095) do |tweet|
      begin
        @new_tweet = Tweet.new
        regex = /[\u{203C}\u{2049}\u{20E3}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2601}\u{260E}\u{2611}\u{2614}-\u{2615}\u{261D}\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2693}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270C}\u{270F}\u{2712}\u{2714}\u{2716}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E7}-\u{1F1EC}\u{1F1EE}-\u{1F1F0}\u{1F1F3}\u{1F1F5}\u{1F1F7}-\u{1F1FA}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3C4}\u{1F3C6}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4F7}\u{1F4F9}-\u{1F4FC}\u{1F500}-\u{1F507}\u{1F509}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F64F}\u{1F680}-\u{1F68A}]/
        @new_tweet.text = tweet.text.gsub regex, ''
        @new_tweet.latitude = tweet.place.bounding_box.coordinates[0][0][1]
        @new_tweet.longitude = tweet.place.bounding_box.coordinates[0][0][0]
        @new_tweet.country_code = tweet.place.country_code
        @new_tweet.location_full_name = tweet.place.full_name
        @new_tweet.FK_user_id = tweet.user.id
        @new_tweet.in_reply_to_user_id = tweet.in_reply_to_user_id
        @new_tweet.in_reply_to_status_id = tweet.in_reply_to_status_id
        @new_tweet.retweet_count = tweet.retweet_count
        @new_tweet.favorite_count = tweet.favorite_count
        @new_tweet.source = tweet.source
        # @new_tweet.timestamp = tweet.timestamp_ms
        @new_tweet.save

        #store new user
        if User.find_by(twitter_id: tweet.user.id).nil?
          @new_user = User.new
          @new_user.twitter_id = tweet.user.id
          @new_user.name = tweet.user.name
          @new_user.screen_name = tweet.user.screen_name
          @new_user.location = tweet.user.location
          @new_user.save
        end

        #store each new mention and new user if mentioned user doesn't exist
        tweet.user_mentions.each { |user_mention|
          if User.find_by(twitter_id: user_mention.id).nil?
            @new_mentioned_user = User.new
            @new_mentioned_user.twitter_id = user_mention.id
            @new_mentioned_user.name = user_mention.name
            @new_mentioned_user.screen_name = user_mention.screen_name
            @new_mentioned_user.save
          end
          @new_mention = Mention.new
          @new_mention.FK_tweet_id = @new_tweet.id
          @new_mention.FK_user_id = tweet.user.id
          @new_mention.save
        }

        #TODO: store each new hashtag here in a similar way to the mentions and users
      rescue Exception => e
        puts "Error #{e}"
        next
      end
    end
  end
end

