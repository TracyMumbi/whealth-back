class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  def index
    if @current_user
      sort_column = params[:sort_column] || 'name' # Default to 'name' if not provided
      sort_direction = params[:sort_direction] || 'asc' # Default to 'asc' if not provided
      search_query = params[:search]

      # Validate the sort direction to prevent SQL injection
      sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : 'asc'

      # Check if the current user is a consultant or a client
      if @current_user.is_consultant
        # Fetch projects associated with the consultant
        @projects = Project.where(consultant_id: @current_user.id)
                           .where("name LIKE ? OR status LIKE ?", "%#{search_query}%", "%#{search_query}%")
                           .order("#{sort_column} #{sort_direction}")
                           .paginate(page: params[:page] || 1, per_page: params[:limit] || 9)
      else
        # Fetch projects associated with the client
        @projects = @current_user.projects
                                 .where("name LIKE ? OR status LIKE ?", "%#{search_query}%", "%#{search_query}%")
                                 .order("#{sort_column} #{sort_direction}")
                                 .paginate(page: params[:page] || 1, per_page: params[:limit] || 9)
      end

      render json: {
        total_pages: @projects.total_pages,
        previous_page: @projects.previous_page,
        next_page: @projects.next_page,
        docs: ActiveModelSerializers::SerializableResource.new(
          @projects,
          each_serializer: ProjectSerializer
        )
      }, scope: {
        params: params
      }
    else
      render json: { error: 'User not found' }, status: :unprocessable_entity
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    render json: @project
  end

  def all
    @projects = Project.all
    render json: @projects
  end



  # POST /projects or /projects.json
  def create
    @project = @current_user.projects.build(project_params)

    if @project.save
      # Create a Quill instance associated with the project
      @quill = Quill.new(content: "", project_id: @project.id)

      if @quill.save
        render json: {
          project: ProjectSerializer.new(@project),
          quill: QuillSerializer.new(@quill)
        }, status: :created, location: @project
      else
        @project.destroy # Rollback project creation if Quill creation fails
        render json: @quill.errors, status: :unprocessable_entity
      end
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
    @project = Project.find_by(id: params[:id])

    if @project.nil?
      render json: { error: 'Project not found' }, status: :not_found
    else
      @project
    end
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :body, :status, :consultant_id, :user_id)
  end
  
end
