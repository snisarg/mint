class NearbyController < ApplicationController

  @@distance_range = 0.2

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

    # Get all tweets that are around the requested points.
    @nearbyTweets = Tweet.where(
        latitude: (params[:lat].to_f-@@distance_range .. params[:lat].to_f+@@distance_range),
        longitude: (params[:lon].to_f-@@distance_range .. params[:lon].to_f+@@distance_range))

    # For each tweet that's in the range :-  This could be optimised using join+select queries directly.
    @nearbyTweets.each do |tweet|
      @user = User.where(twitter_id: tweet.FK_user_id).take
      @nearbyResult.push(
          NearbyResult.new(tweet.text, tweet.latitude, tweet.longitude, tweet.location_full_name, tweet.source, @user.name, @user.screen_name))
    end
    render json: @nearbyResult
  end

end
