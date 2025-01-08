require 'httparty'
require 'rgeo'
require 'rgeo/geos' # Optional but recommended

class HereService
  include HTTParty
  base_uri 'https://discover.search.hereapi.com/v1'

  def initialize(api_key)
    @api_key = api_key
    @factory = RGeo::Geographic.spherical_factory(srid: 4326)
  end

  def get_attractions_by_location(latitude, longitude, radius = 5000)
    begin
        options = {
          query: {
            apiKey: @api_key,
            q: 'tourist attractions',
            size: 10,
            at: "#{latitude},#{longitude}" # Use 'at' parameter for location
          }
        }

      Rails.logger.debug "HERE API Request: #{self.class.get('/discover', options).request.uri}"

      response = self.class.get('/discover', options)

      Rails.logger.debug "HERE API Response: #{response.body}"

      if response.success?
        JSON.parse(response.body)
      else
        Rails.logger.error "HERE API Error: #{response.code} - #{response.body}"
        { error: "Unable to fetch data", status: response.code, message: response.message }
      end
    rescue StandardError => e
      Rails.logger.error "Error during HERE API request: #{e.message}"
      { error: "An error occurred during the request", message: e.message }
    end
  end
end