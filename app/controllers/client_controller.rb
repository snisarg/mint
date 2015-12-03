class ClientController < ApplicationController
  def index

    key = 'sourceCountCache' << params[:lat1].to_s << params[:lat2].to_s << params[:lon1].to_s << params[:lon2].to_s

    @sourceCount = Rails.cache.fetch(key) do
      puts("Cache miss")
      #Find the sources in the bounded region
      @sourceCount = Tweet.where(
          latitude: (params[:lat1].to_f .. params[:lat2].to_f),
          longitude: (params[:lon2].to_f .. params[:lon1].to_f)).group('source').count
    end

    render json: @sourceCount
  end
end
