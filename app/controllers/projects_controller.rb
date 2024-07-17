class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  def index
    @projects = Project.all
    render json: @projects
  end

  # GET /projects/1 or /projects/1.json
  def show
    render json: @project
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: {
        project: ProjectSerializer.new(@project)
      }, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if @project.destroy
      render json: { message: 'Project was successfully destroyed.' }, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:user_id, :name, :status)
  end
end
