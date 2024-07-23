class ConsultantsController < ApplicationController
  before_action :set_consultant, only: %i[show edit update destroy]

  # GET /consultants or /consultants.json
  def index
    @consultants = Consultant.all
    render json: @consultants
  end

  # GET /consultants/1 or /consultants/1.json
  def show
    render json: @consultant
  end

  # POST /consultants or /consultants.json
  def create
    @consultant = Consultant.new(consultant_params)

    if @consultant.save
      render json: @consultant, status: :created, location: @consultant
    else
      render json: @consultant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /consultants/1 or /consultants/1.json
  def update
    if @consultant.update(consultant_params)
      render json: @consultant
    else
      render json: @consultant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /consultants/1 or /consultants/1.json
  def destroy
    if @consultant.destroy
      render json: { message: 'Consultant was successfully destroyed.' }, status: :ok
    else
      render json: { errors: @consultant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_consultant
    @consultant = Consultant.find(params[:id])
  end

  def consultant_params
    params.require(:consultant).permit(:name, :phone, :gender, :date_of_birth, :email, :password, :speciality, :board_number, :experience, :is_client, :is_consultant)
  end
end
