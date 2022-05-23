class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
    @shelters_with_pending_apps = Shelter.joins(pets: :application_forms).where("application_forms.status = 'Pending'")
    # binding.pry
  end

end
