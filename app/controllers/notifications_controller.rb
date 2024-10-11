class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show edit update destroy]

  # GET /notifications or /notifications.json
  def index
    sort_column = params[:sort_column] || 'created_at' # Default to 'created_at' if not provided
    sort_direction = params[:sort_direction] || 'desc' # Default to 'desc' if not provided
    search_query = params[:search] || ''
    start_date = params[:start_date] || Date.new(1900, 1, 1)
    end_date = params[:end_date] || Date.current

    # Validate the sort direction to prevent SQL injection
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : 'desc'

    # Fetch the current user's projects (whether user or consultant)
    user_projects = if @current_user.is_a?(User)
                      @current_user.projects
                    else
                      Project.where(consultant: @current_user)
                    end

    # Fetch notifications related to the current user's projects
    @notifications = Notification
                      .joins(appointment: :project)
                      .where(appointments: { project: user_projects })
                      .where("message LIKE ?", "%#{search_query}%")
                      .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                      .order("#{sort_column} #{sort_direction}")
                      .paginate(page: params[:page] || 1, per_page: params[:limit] || 10)

    render json: {
      total_pages: @notifications.total_pages,
      previous_page: @notifications.previous_page,
      next_page: @notifications.next_page,
      docs: ActiveModelSerializers::SerializableResource.new(
        @notifications,
        each_serializer: NotificationSerializer
      )
    }, scope: {
      params: params
    }
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    render json: @notification, scope: { params: params }
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      render json: { 
        notification: NotificationSerializer.new(@notification, scope: { params: params })
      }, status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    if @notification.update(notification_params)
      render json: { notification: NotificationSerializer.new(@notification, scope: { params: params }) }
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy!
    render json: { message: "Notification was successfully destroyed." }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:message, :appointment_id)
  end
end
