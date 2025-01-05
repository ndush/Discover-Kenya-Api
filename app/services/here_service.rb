class HereService
  include HTTParty
  base_uri 'https://discover.search.hereapi.com/v1'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_attractions_by_location(latitude, longitude)
    response = self.class.get('/discover', query: { 
      at: "#{latitude},#{longitude}", 
      apiKey: @api_key, 
      q: 'tourist attractions', 
      size: 10  
    })

    if response.success?
      JSON.parse(response.body)
    else
      { error: "Unable to fetch data", status: response.code, message: response.message }
    end
  end
end
