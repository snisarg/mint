class TweetsController < ApplicationController
  def show
    @tweet = Tweet.find(params[:id])
  end

  def new
    @tweet = Tweet.new
  end

  def create
      # render plain: params[:tweet].inspect
      @tweet = Tweet.new(tweet_params)
      hashtag = @tweet.hashtag
      tweet_content = TwitterApiController.new.fetch_tweets(hashtag)

      tweet_content.each do |t|
        if t != tweet_content.last
          @next_tweet = Tweet.new
          @next_tweet.hashtag = hashtag
          @next_tweet.tweet_text = t.text
          @next_tweet.save
        else
          @tweet.tweet_text = t.text
          @tweet.save
        end
      end
      redirect_to @tweet
  end

  def destroy
    @article = Tweet.find(params[:id])
    @article.destroy

    redirect_to tweets_path
  end

  private
    def tweet_params
      params.require(:tweet).permit(:hashtag)
    end

end
