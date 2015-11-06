class ClientController < ApplicationController
  def index

    #Find the sources in the bounded region
    @sourceCount = Tweet.where(
        latitude: (params[:lat1].to_f .. params[:lat2].to_f),
        longitude: (params[:lon2].to_f .. params[:lon1].to_f)).group('source').count

    render json: @sourceCount
  end
end
