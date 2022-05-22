class AdminApplicationFormsController < ApplicationController

  def show
    @application_form = ApplicationForm.find(params[:id])
    @application_pets = ApplicationPet.where(application_form_id: @application_form.id)
    @pets = @application_form.pets
  end

  def update
    # binding.pry
  end
end
