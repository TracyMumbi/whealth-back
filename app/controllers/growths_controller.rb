class GrowthsController < ApplicationController
  before_action :set_growth, only: %i[show edit update destroy]

  # GET /growths or /growths.json
  def index
    sort_column = params[:sort_column] || 'created_at'
    sort_direction = params[:sort_direction] || 'desc'
    search_query = params[:search] || ''
    start_date = params[:start_date] || Date.new(1900, 1, 1)
    end_date = params[:end_date] || Date.current

    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : 'desc'

    @growths = Growth
                .where("weight LIKE :query OR height LIKE :query OR age LIKE :query OR length LIKE :query OR head_circumference LIKE :query", query: "%#{search_query}%")
                .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                .order("#{sort_column} #{sort_direction}")
                .paginate(page: params[:page] || 1, per_page: params[:limit] || 10)

    render json: {
      total_pages: @growths.total_pages,
      previous_page: @growths.previous_page,
      next_page: @growths.next_page,
      docs: ActiveModelSerializers::SerializableResource.new(
        @growths,
        each_serializer: GrowthSerializer
      )
    }, scope: {
      params: params
    }
  end

  # GET /growths/user/:user_id
  def user_growths
    user_id = params[:user_id] # Get the user_id from the URL

    @growths = Growth.where(user_id: user_id)

    if @growths.exists?
      render json: ActiveModelSerializers::SerializableResource.new(
        @growths,
        each_serializer: GrowthSerializer
      )
    else
      render json: { message: "No growth records found for the user." }, status: :not_found
    end
  end

  # GET /growths/1 or /growths/1.json
  def show
    render json: @growth, scope: { params: params }
  end

  # POST /growths or /growths.json
  def create
    @growth = Growth.new(growth_params)

    if @growth.save
      render json: { 
        growth: GrowthSerializer.new(@growth, scope: { params: params })
      }, status: :created
    else
      render json: @growth.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /growths/1 or /growths/1.json
  def update
    if @growth.update(growth_params)
      render json: { growth: GrowthSerializer.new(@growth, scope: { params: params }) }
    else
      render json: @growth.errors, status: :unprocessable_entity
    end
  end

  # DELETE /growths/1 or /growths/1.json
  def destroy
    @growth.destroy!
    render json: { message: "Growth was successfully destroyed." }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_growth
    @growth = Growth.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def growth_params
    params.require(:growth).permit(:weight, :height, :age, :user_id, :length, :head_circumference)
  end
end
