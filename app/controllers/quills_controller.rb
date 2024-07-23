class QuillsController < ApplicationController
  before_action :set_quill, only: %i[ show edit update destroy ]

  # GET /quills or /quills.json
  def index
    @quills = Quill.all
  end

  # GET /quills/1 or /quills/1.json
  def show
  end

  # GET /quills/new
  def new
    @quill = Quill.new
  end

  # GET /quills/1/edit
  def edit
  end

  # POST /quills or /quills.json
  def create
    @quill = Quill.new(quill_params)

    respond_to do |format|
      if @quill.save
        format.html { redirect_to quill_url(@quill), notice: "Quill was successfully created." }
        format.json { render :show, status: :created, location: @quill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quills/1 or /quills/1.json
  def update
    respond_to do |format|
      if @quill.update(quill_params)
        format.html { redirect_to quill_url(@quill), notice: "Quill was successfully updated." }
        format.json { render :show, status: :ok, location: @quill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quills/1 or /quills/1.json
  def destroy
    @quill.destroy!

    respond_to do |format|
      format.html { redirect_to quills_url, notice: "Quill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quill
      @quill = Quill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quill_params
      params.require(:quill).permit(:content, :project_id)
    end
end
