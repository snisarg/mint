class HashtagController < ApplicationController
  def index
    hashtag_request_list = params[:tags].split(',')
    hash_tweets = Hashtag.where(text: hashtag_request_list)
               .joins('JOIN hashtag_lists ON hashtags.id=hashtag_lists.FK_hashtag_id JOIN tweets ON hashtag_lists.FK_tweet_id=tweets.id')
               .select('hashtags.id, hashtags.text, tweets.id, tweets.text, tweets.latitude, tweets.longitude')
    render json: hash_tweets
  end

  def popular
    @sourceCount = Tweet.where(
        latitude: (params[:lat1].to_f .. params[:lat2].to_f),
        longitude: (params[:lon2].to_f .. params[:lon1].to_f))
    .joins('JOIN hashtag_lists ON tweets.id=hashtag_lists.FK_tweet_id JOIN hashtags ON hashtag_lists.FK_hashtag_id=hashtags.id')
    .group('hashtags.text').count

    render json: @sourceCount
  end

  def autocomplete
    render json: Hashtag.where('text LIKE ?', '%'+params[:term]+'%')
  end

end
