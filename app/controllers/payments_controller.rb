require_relative './Payments/Mpesa/mpesa_express'

class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  # GET /payments or /payments.json
  def index
    @payments = Payment.all
    render json: @payments
  end

  # GET /payments/1 or /payments/1.json
  def show
    render json: @payment
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments/stk_push
  def stk_push
    # Ensure to handle the response from mpesa_express appropriately
    response = mpesa_express(1, params[:phone])
    render json: { message: "Payment request initiated", response: response }
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.json { render json: @payment, status: :created }
      else
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def payment_params
    params.require(:payment).permit(:project_id, :amount, :user_id, :paid_at)
  end
end
