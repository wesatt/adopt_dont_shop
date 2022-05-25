class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :application_forms, through: :application_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def application_status(application_form)
    application_pet = ApplicationPet.where(application_form_id: application_form.id, pet_id: self.id).first
    if application_pet
      application_pet.status
    else
      nil
    end
  end
end
