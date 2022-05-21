class ApplicationFormsController < ApplicationController

  def index
    @application_forms = ApplicationForm.all
  end

  def show
    @application_form = ApplicationForm.find(params[:id])
  end

  def new
    # redirect_to '.......'
  end

  def create
    application_form = ApplicationForm.new(application_form_params)
    application_form.status = "In Progress"
    if application_form.save
      # redirect_to '/application_forms/#{application_form.id}'
      redirect_to "/application_forms/#{application_form.id}"
    else
      # binding.pry
      redirect_to '/application_forms/new'
      flash[:alert] = "Error: #{error_message(application_form.errors)}"
    end

    # if shelter.save
    #   redirect_to '/shelters'
    # else
    #   redirect_to '/shelters/new'
    #   flash[:alert] = "Error: #{error_message(shelter.errors)}"
    # end
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

  def add_pet
    ApplicationPet.create(application_form_id: params[:id], pet_id: params[:pet_id])
    redirect_to "/application_forms/#{params[:id]}/"
  end

  private
    def application_form_params
      params.permit(:name, :street_address, :city, :state, :zip_code)
    end

end
