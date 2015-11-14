class NearbyController < ApplicationController

  @@distance_range

  def index
    if params[:radius].blank?
      @@distance_range = 0.1
    else
      @@distance_range = params[:radius].to_f
    end

    @nearbyTweets = Tweet.where(
        latitude: (params[:lat].to_f-@@distance_range .. params[:lat].to_f+@@distance_range),
        longitude: (params[:lon].to_f-@@distance_range .. params[:lon].to_f+@@distance_range))
          .joins('JOIN users ON tweets.FK_user_id=users.twitter_id')
          .select('tweets.text, tweets.latitude, tweets.longitude, tweets.location_full_name, tweets.source, users.name, users.screen_name')

    render json: @nearbyTweets
  end

end
