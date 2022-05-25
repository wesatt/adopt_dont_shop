class ApplicationFormsController < ApplicationController

  def index
    @application_forms = ApplicationForm.all
  end

  def show
    @application_form = ApplicationForm.find(params[:id])
  end

  def new
  end

  def create
    application_form = ApplicationForm.new(application_form_params)
    if application_form.update(status: "In Progress")
      redirect_to "/application_forms/#{application_form.id}"
    else
      redirect_to '/application_forms/new'
      flash[:alert] = "Error: #{error_message(application_form.errors)}"
    end
  end

  def update
    if params[:description] != ""
      application_form = ApplicationForm.find(params[:id])
      application_form.update(description: params[:description], status: "Pending")
      redirect_to "/application_forms/#{params[:id]}/"
    else
      redirect_to "/application_forms/#{params[:id]}/"
      flash[:alert] = "Error: Description cannot be blank."
    end
  end

  private
    def application_form_params
      params.permit(:name, :street_address, :city, :state, :zip_code)
    end

end
