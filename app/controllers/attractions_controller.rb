class AttractionsController < ApplicationController
  def index
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude.present? && longitude.present?
      service = HereService.new(ENV['HERE_API_KEY']) 
      attractions = service.get_attractions_by_location(latitude, longitude)

      if attractions['error']
        render json: { error: attractions['error'], message: attractions['message'] }, status: :bad_request
      else
        render json: attractions
      end
    else
      render json: { error: 'Latitude and longitude parameters are required.' }, status: :bad_request
    end
  end
end
