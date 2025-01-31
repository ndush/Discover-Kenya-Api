class AttractionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :approve, :reject]
  before_action :set_attraction, only: [:approve, :reject]

  # GET /attractions?latitude=1.4033&longitude=35.0873&category=1&radius=5000
  # GET /attractions/search?name=diani beaches&latitude=1.4033&longitude=35.0873&radius=5000&category=1
def search
    name = params[:name]
    latitude = params[:latitude]
    longitude = params[:longitude]
    radius = params[:radius] || 5000
    category = params[:category]

    if name.present? && latitude.present? && longitude.present?
      service = HereService.new(ENV['HERE_API_KEY'])
      attractions = service.get_attractions_by_name(name, latitude, longitude, radius, category)  # Call the public method
    else
      render json: { error: 'Name, Latitude, and Longitude are required' }, status: :unprocessable_entity
      return
    end

    if attractions['error']
      render json: { error: attractions['error'], message: attractions['message'] }, status: :bad_request
    else
      items = attractions['items']
      formatted_attractions = format_attractions(items) if items.present?

      render json: formatted_attractions || { message: 'No attractions found' }, status: :ok
    end
  end

  # POST /attractions
# POST /attractions
def create
  if current_user.posts_today.count >= ENV.fetch("POST_LIMIT", 5).to_i
    return render json: { error: 'Post limit exceeded for today.' }, status: :too_many_requests
  end

  # Geocode or set address if needed
  @attraction = Attraction.new(attraction_params)
  @attraction.user_id = current_user.id
  @attraction.status = :pending

  # Save the attraction and handle geocoding if applicable
  if @attraction.save
    # Filter out any nil attributes from the response
    attraction_response = @attraction.attributes.compact

    render json: attraction_response, status: :created
  else
    render json: @attraction.errors, status: :unprocessable_entity
  end
end




  # PATCH /attractions/:id/approve
  def approve
    if current_user.moderator?
      @attraction.update!(status: :approved)
      notify_user(@attraction.user, 'Your attraction has been approved.')
      render json: @attraction, status: :ok
    else
      render json: { error: 'You are not authorized to approve this attraction.' }, status: :forbidden
    end
  end

  # PATCH /attractions/:id/reject
  def reject
    if current_user.moderator?
      Rails.logger.debug("Rejecting attraction with ID: #{@attraction.id}")
      @attraction.update!(status: :rejected)
      notify_user(@attraction.user, 'Your attraction has been rejected.')
      render json: @attraction, status: :ok
    else
      render json: { error: 'You are not authorized to reject this attraction.' }, status: :forbidden
    end
  end

  private

  def set_attraction
    @attraction = Attraction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Attraction not found.' }, status: :not_found
  end

  def attraction_params
  params.require(:attraction).permit(:name, :description, :location, :category, :latitude, :longitude, :country, :price)
  end


 def format_attractions(attractions)
  attractions.map do |attraction|
    # Assuming the address or other property contains 'Kenya' or its variant
    if attraction["address"] && attraction["address"]["label"].include?("Kenya")
      {
        name: attraction["title"],          # Use "title" from the API response
        address: attraction["address"] ? attraction["address"]["label"] : 'No Address',  # Use label for address
        id: attraction["id"]                # Include id or any other necessary fields
      }
    end
  end.compact  # This removes any nil entries from the array
end


  def notify_user(user, message)
    Notification.create(user: user, message: message)
  end
end
