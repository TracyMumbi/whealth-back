require_relative "./Payments/Mpesa/auth.rb"
require_relative "./Payments/Mpesa/mpesa_time.rb"
require_relative "./Payments/Mpesa/mpesa_express.rb"

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit query ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
    render json: @transaction
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    total_cart_price = 1 # Adjust this value as needed for your logic

    phone_no = params[:phone].to_i.zero? ? @current_user.phone.to_i : params[:phone].to_i

    response = mpesa_express( 
      total_cart_price, 
      phone_no
    )
    
    if response.key?("CheckoutRequestID")
      @transaction = Transaction.new( 
        user_id: params[:user_id],
        transaction_code: response["CheckoutRequestID"],
        amount: total_cart_price
      )
      
      if @transaction.save
        render json: { 
          express_response: response,
          transaction: TransactionSerializer.new(@transaction), 
        }, 
        status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity 
      end
    else
      render json: { notice: "Couldn't create transaction, Mpesa could not be processed." }, status: :unprocessable_entity
    end
  end

  # POST /transactions/create_subscription
  def create_subscription
    subscription_fee = 10 # The subscription fee amount in your business logic
    phone_no = params[:phone_no].to_i.zero? ? @current_user.phone_no.to_i : params[:phone_no].to_i

    response = mpesa_express(subscription_fee, phone_no)

    if response.key?("CheckoutRequestID")
      @transaction = Transaction.new(
        user_id: @current_user.id,
        transaction_code: response["CheckoutRequestID"],
        amount: subscription_fee,
        transaction_type: 'subscription'
      )
      
      if @transaction.save
        render json: { 
          express_response: response, 
          transaction: TransactionSerializer.new(@transaction), 
          message: "Subscription payment initiated. Please confirm the payment." 
        }, status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    else
      render json: { notice: "Subscription payment failed, Mpesa could not be processed." }, status: :unprocessable_entity
    end
  end

# POST /transactions/query
def query
  t = mpesa_time
  pass_key = "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
  paybill = 174379
  url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
  password = Base64.strict_encode64("#{paybill}#{pass_key}#{t}")

  data = {
    "BusinessShortCode": paybill,
    "Password": password,
    "Timestamp": t,
    "CheckoutRequestID": @transaction.transaction_code,
  }

  token = access_token

  begin
    response = Excon.post(url, body: JSON.generate(data), headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" })
    data = JSON.parse(response.body)

    # Ensure subscription_status is only updated for users, not consultants
    if @current_user.is_a?(User)
      if data["ResultDesc"] == "The service request is processed successfully."
        @current_user.update(subscription_status: true)
        @transaction.update(status: 1) # Mark as successful
      elsif data["ResultDesc"] == "Request cancelled by user"
        @current_user.update(subscription_status: false)
        @transaction.update(status: 0) # Mark as canceled
      end
    end

    render json: {
      query_response: data,
      transaction: TransactionSerializer.new(@transaction),
    }
  rescue Excon::Error => e
    render json: { error: "Excon error: #{e.message}" }, status: :bad_request
  rescue JSON::ParserError => e
    render json: { error: "JSON parsing error: #{e.message}" }, status: :bad_request
  rescue StandardError => e
    render json: { error: "Unexpected error: #{e.message}" }, status: :internal_server_error
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:transaction_code, :user_id, :amount)
    end
end
