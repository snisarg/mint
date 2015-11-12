class HashtagController < ApplicationController
  def index
    hashtag_request_list = params[:tags].split(',')
    hash_tweets = Hashtag.where(text: hashtag_request_list)
               .joins('JOIN hashtag_lists ON hashtags.id=hashtag_lists.FK_hashtag_id JOIN tweets ON hashtag_lists.FK_tweet_id=tweets.id')
               .select('hashtags.id, hashtags.text, tweets.id, tweets.text, tweets.latitude, tweets.longitude')
    render json: hash_tweets
  end
end
