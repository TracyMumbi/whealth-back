class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show edit update destroy]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
    render json: @appointments
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    render json: @appointment, scope: { params: params }
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: { 
        appointment: AppointmentSerializer.new(@appointment, scope: { params: params }) 
      }, scope: { params: params }, status: :created
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
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:title, :body)
  end
end
