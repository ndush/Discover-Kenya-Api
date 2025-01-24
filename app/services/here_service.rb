require 'httparty'
require 'json'
require 'redis'

class HereService
  include HTTParty
  base_uri 'https://discover.search.hereapi.com/v1'

  def initialize(api_key)
    @api_key = api_key
    @redis = Redis.new 
  end

def get_attractions_by_location(latitude, longitude, radius, category)
  fetch_attractions(latitude, longitude, radius)
end
  def fetch_attractions(latitude, longitude, radius = 5000)
    cache_key = "attractions_#{latitude}_#{longitude}_#{radius}"
    
    cached_response = @redis.get(cache_key)
    return JSON.parse(cached_response) if cached_response

    options = {
      query: {
        apiKey: @api_key,
        q: 'tourist attractions',
        at: "#{latitude},#{longitude}",
        radius: radius,
        size: 10 
      }
    }

    
    response = self.class.get('/discover', options)

    if response.success?
     
      @redis.setex(cache_key, 3600, response.body) 
      JSON.parse(response.body) 
    else
      handle_error(response) 
    end
  rescue StandardError => e
    { error: "An error occurred during the request", message: e.message }
  end

  private 

  def handle_error(response)
    {
      error: "Unable to fetch data",
      status: response.code,
      message: response.message
    }
  end
end