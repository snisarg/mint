class NearbyController < ApplicationController

  @@distance_range

  class NearbyResult
        def initialize(_text, _lat, _lon, _location_full, _source, _name, _screen_name)
            @text = _text
            @latitude = _lat
            @longitude = _lon
            @location_full = _location_full
            @source = _source
            @name = _name
            @screen_name = _screen_name
          end
      end

  def index
    @nearbyResult = Array.new
    if params[:radius].blank?
      @@distance_range = 0.1
    else
      @@distance_range = params[:radius].to_f
    end

    @nearbyTweets = Tweet.where(
        latitude: (params[:lat].to_f-@@distance_range .. params[:lat].to_f+@@distance_range),
        longitude: (params[:lon].to_f-@@distance_range .. params[:lon].to_f+@@distance_range))
          #.joins('JOIN users ON tweets.FK_user_id=users.twitter_id')
          #.select('tweets.text, tweets.latitude, tweets.longitude, tweets.location_full_name, tweets.source, users.name, users.screen_name')

          # For each tweet that's in the range :-  This could be optimised using join+select queries directly.
        @nearbyTweets.each do |tweet|
            @user = User.where(twitter_id: tweet.FK_user_id).take
            @nearbyResult.push(
                    NearbyResult.new(tweet.text, tweet.latitude, tweet.longitude, tweet.location_full_name, tweet.source, @user.name, @user.screen_name))
          end
        render json: @nearbyResult
    #render json: @nearbyTweets
  end

end