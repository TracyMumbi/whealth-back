class ConsultantsController < ApplicationController
  before_action :set_consultant, only: %i[ show edit update destroy ]

  # GET /consultants or /consultants.json
  def index
    @consultants = Consultant.all
  end

  # GET /consultants/1 or /consultants/1.json
  def show
  end

  # GET /consultants/new
  def new
    @consultant = Consultant.new
  end

  # GET /consultants/1/edit
  def edit
  end

  # POST /consultants or /consultants.json
  def create
    @consultant = Consultant.new(consultant_params)

    respond_to do |format|
      if @consultant.save
        format.html { redirect_to consultant_url(@consultant), notice: "Consultant was successfully created." }
        format.json { render :show, status: :created, location: @consultant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @consultant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultants/1 or /consultants/1.json
  def update
    respond_to do |format|
      if @consultant.update(consultant_params)
        format.html { redirect_to consultant_url(@consultant), notice: "Consultant was successfully updated." }
        format.json { render :show, status: :ok, location: @consultant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @consultant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consultants/1 or /consultants/1.json
  def destroy
    @consultant.destroy!

    respond_to do |format|
      format.html { redirect_to consultants_url, notice: "Consultant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultant
      @consultant = Consultant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def consultant_params
      params.require(:consultant).permit(:name, :phone, :gender, :date_of_birth, :email, :password, :speciality, :board_number, :experience, :is_client, :is_consultant)
    end
end
