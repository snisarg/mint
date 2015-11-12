class UserController < ApplicationController
  def index
    user_list = params[:handle].split(',')
    user = User.where(screen_name: user_list).joins("LEFT JOIN tweets ON users.twitter_id = tweets.FK_user_id")
               .select("users.name, users.screen_name, users.twitter_id, tweets.text, tweets.latitude, tweets.longitude, tweets.source")
    #user = User.where(screen_name: user_list).join(:tweet) #.select("twitter_id")
    #result_tweet = Tweet.where(FK_user_id: user)
    render json: user
  end
end
