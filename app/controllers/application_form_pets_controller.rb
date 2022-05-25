class ApplicationFormPetsController < ApplicationController

  def create
    ApplicationPet.create(application_form_id: params[:id], pet_id: params[:pet_id])
    redirect_to "/application_forms/#{params[:id]}/"
  end
end
