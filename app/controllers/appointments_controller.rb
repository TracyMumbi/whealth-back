class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show edit update destroy]
  before_action :set_project, only: %i[create index]

  # GET /projects/:project_id/appointments
  def index
    if @current_user
      @appointments = @project.appointments
      render json: @appointments
    else
      render json: { error: 'User not found' }, status: :unprocessable_entity
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    render json: @appointment, scope: { params: params }
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = @project.appointments.new(appointment_params)

    if @appointment.save
      render json: { 
        appointment: AppointmentSerializer.new(@appointment, scope: { params: params }) 
      }, scope: { params: params }, status: :created

      # Create a notification and broadcast to the consultant's channel
      consultant_channel_name = "consultant_channel_#{@project.consultant_id}"
      
      ConsultantChannel.broadcast_to(
        consultant_channel_name,
        message: { 
          message: "You have a new appointment",
          appointment: AppointmentSerializer.new(@appointment),
        }
      )
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    if @appointment.update(appointment_params)
      render json: @appointment, scope: { params: params }
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    if @appointment.destroy
      render json: { message: 'Appointment was successfully destroyed.' }, status: :ok
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])
    if @appointment.nil?
      render json: { error: 'Appointment not found' }, status: :not_found
    end
  end

  def set_project
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      render json: { error: 'Project not found' }, status: :not_found
    end
  end

  def appointment_params
    params.require(:appointment).permit(:title, :body, :status, :date, :project_id)
  end
end
