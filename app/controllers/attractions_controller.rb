class AttractionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :approve, :reject]
  before_action :set_attraction, only: [:approve, :reject]

  # GET /attractions?latitude=1.4033&longitude=35.0873
  def index
    latitude = params[:latitude]
    longitude = params[:longitude]
    radius = params[:radius] || 5000

    if latitude.present? && longitude.present?
      service = HereService.new(ENV['HERE_API_KEY'])
      attractions = service.get_attractions_by_location(latitude, longitude, radius)

      if attractions['error']
        render json: { error: attractions['error'], message: attractions['message'] }, status: :bad_request
      else
        render json: attractions
      end
    else
      attractions = Attraction.all
      render json: attractions
    end
  end

  # POST /attractions
  def create
    if current_user.posts_today.count >= ENV.fetch("POST_LIMIT", 5).to_i
      return render json: { error: 'Post limit exceeded for today.' }, status: :too_many_requests
    end

    location = "POINT(#{attraction_params[:longitude]} #{attraction_params[:latitude]})"
    @attraction = Attraction.new(attraction_params.merge(location: location))
    @attraction.user_id = current_user.id
    @attraction.status = :pending

    if @attraction.save
      render json: @attraction, status: :created
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
    params.require(:attraction).permit(:name, :description, :location, :category, :latitude, :longitude, :country)
  end

  def notify_user(user, message)
    Notification.create(user: user, message: message)
  end
end
