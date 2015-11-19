class NearbyController < ApplicationController

  def index
    if params[:radius].blank?
      @distance_range = 0.1
    else
      @distance_range = params[:radius].to_f
    end

    lat = params[:lat].to_f
    lon = params[:lon].to_f

    minLat = (params[:lat].to_f - @distance_range).floor
    maxLat = (params[:lat].to_f + @distance_range).ceil
    minLon = (params[:lon].to_f - @distance_range).floor
    maxLon = (params[:lon].to_f + @distance_range).ceil

    curLatDiff = maxLat - minLat
    curLonDiff = maxLon - minLon

    @maxCacheLat = Rails.cache.fetch('maxCacheLat') do
      @maxCacheLat = curLatDiff
    end

    puts(@maxCacheLat)
    if (@maxCacheLat < curLatDiff)
      Rails.cache.write('maxCacheLat', curLatDiff)
    end

    @maxCacheLon = Rails.cache.fetch('maxCacheLon') do
      @maxCacheLon = curLonDiff
    end
    puts(@maxCacheLon)
    if (@maxCacheLon < curLonDiff)
      Rails.cache.write('maxCacheLon', curLonDiff)
    end

    @subsetOfCachedBlock = false

    lambda do
      x1 = maxLat - @maxCacheLat
      while x1 <= minLat+@maxCacheLat
        y1 = maxLon - @maxCacheLon
        while y1 <= minLon+@maxCacheLon
          x2 = x1 + @maxCacheLat
          while x2 >= maxLat
            y2 = y1 + @maxCacheLon
            while y2 >= maxLon
              @cacheKey = 'nearbyCache' << x1.to_s << x2.to_s << y1.to_s << y2.to_s
              puts(@cacheKey)
              if (Rails.cache.exist?(@cacheKey))
                puts("hit: " + @cacheKey)
                @subsetOfCachedBlock = true
                return
              end
              y2 -= 1
            end
            x2 -= 1
          end
          y1 += 1
        end
        x1 += 1
      end
    end.call

    if (@subsetOfCachedBlock == true)
      puts("Cache hit")
      @nearbyTweets = Rails.cache.read(@cacheKey)
      puts("Retrieved from cache with key: " + @cacheKey)
    else
      puts("Cache miss")
      key = 'nearbyCache' << minLat.to_s << maxLat.to_s << minLon.to_s << maxLon.to_s
      @nearbyTweets = Tweet.where(latitude: (minLat .. maxLat), longitude: (minLon .. maxLon))
        .joins('JOIN users ON tweets.FK_user_id=users.twitter_id')
        .select('tweets.text, tweets.latitude, tweets.longitude, tweets.location_full_name, tweets.source, users.name, users.screen_name')
      Rails.cache.write(key, @nearbyTweets)
      puts("Inserted into cache with key: " + key)
    end

    # @nearbyTweets = Rails.cache.fetch(key) do
    #   @nearbyTweets = Tweet.where(latitude: (minLat .. maxLat), longitude: (minLon .. maxLon))
    #         .joins('JOIN users ON tweets.FK_user_id=users.twitter_id')
    #         .select('tweets.text, tweets.latitude, tweets.longitude, tweets.location_full_name, tweets.source, users.name, users.screen_name')
    # end

    @nearbyTweetsFiltered = @nearbyTweets.select { |tweet|
      tweet.latitude <= lat + @distance_range &&
      tweet.latitude >= lat - @distance_range &&
      tweet.longitude <= lon + @distance_range &&
      tweet.longitude >= lon - @distance_range
    }
    puts(@nearbyTweetsFiltered.size())
    render json: @nearbyTweetsFiltered
  end
end
