class HereService
  include HTTParty
  base_uri 'https://discover.search.hereapi.com/v1'

  def initialize(api_key)
    @api_key = api_key
    @redis = Redis.new
  end

  # Public method for name-based search
  def get_attractions_by_name(name, latitude, longitude, radius = 5000, category = nil)
    fetch_attractions_by_name(name, latitude, longitude, radius, category)
  end

  private

  # Fetch attractions with caching and error handling
  def fetch_attractions_by_name(name, latitude, longitude, radius = 5000, category = nil)
    cache_key = "attractions_name_#{name}_#{latitude}_#{longitude}_#{radius}"

    cached_response = @redis.get(cache_key)
    return JSON.parse(cached_response) if cached_response

    options = {
  query: {
    apiKey: @api_key,
    q: name,
    at: "#{latitude},#{longitude}",
    radius: radius,
    size: 50,
    cat: category,
    country: 'Kenya'  # Filter by Kenya
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
end
