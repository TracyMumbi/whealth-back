class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show edit update destroy]

  # GET /documents or /documents.json
  def index
    @documents = Document.all
    render json: @documents.map { |document| document_attributes(document) }
  end

  # GET /documents/1 or /documents/1.json
# Example in Rails controller
def show
  document = Document.find(params[:id])
  respond_to do |format|
    format.pdf do
      pdf = render_to_string pdf: "document_#{document.id}", template: "documents/show.pdf.erb", layout: "pdf.html.erb"
      send_data pdf, filename: "document_#{document.id}.pdf", type: 'application/pdf', disposition: 'inline'
    end
  end
end


  # POST /documents or /documents.json
  def create
    document = Document.new
    document.file_data.attach(document_params[:file_data])
    
    if document.save
      render json: document_attributes(document), status: :created
    else
      render json: document.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    if @document.update(document_params)
      render json: document_attributes(@document), status: :ok
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:file_data)
  end

  def document_attributes(document)
    {
      id: document.id,
      file_data: url_for(document.file_data),
      created_at: document.created_at,
      updated_at: document.updated_at
    }
  end
end
