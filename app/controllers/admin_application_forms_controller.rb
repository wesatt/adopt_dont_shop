class AdminApplicationFormsController < ApplicationController

  def show
    @application_form = ApplicationForm.find(params[:id])
    @pets = @application_form.pets
  end

  def update
    application_pet = ApplicationPet.where(application_form_id: params[:id]).where(pet_id: params[:pet_id]).first
    if params[:status] == "Approved"
      application_pet.update(status: "Approved")
    else
      application_pet.update(status: "Rejected")
    end
    redirect_to "/admin/application_forms/#{params[:id]}"
  end
end
