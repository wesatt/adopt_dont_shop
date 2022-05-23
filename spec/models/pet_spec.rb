require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:application_forms).through(:application_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe ".application_status(application_form)" do
      it "returns the application_pets approval status" do
        # status should be empty, Approved, or Rejected
        shelter_1 = Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: true, rank: 9)

        pet_1 = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter_1.id)
        pet_3 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_1.id)

        applicationform_1 = ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", description: "Please...gimme animal.", status: "Pending")
        applicationform_2 = ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "I would like an animal, please.", status: "Pending")
        applicationform_3 = ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals.", status: "Pending")
        applicationform_5 = ApplicationForm.create(name: "Rutger", street_address: "5555 This Street", city: "Denver", state: "CO", zip_code: "80012", description: "Animals: I love em", status: "Pending")

        application_pets_1 = ApplicationPet.create(pet: pet_1, application_form: applicationform_1)
        application_pets_2 = ApplicationPet.create(pet: pet_1, application_form: applicationform_2, status: "Rejected")
        application_pets_3 = ApplicationPet.create(pet: pet_1, application_form: applicationform_3, status: "Approved")
        application_pets_4 = ApplicationPet.create(pet: pet_2, application_form: applicationform_2)
        application_pets_5 = ApplicationPet.create(pet: pet_2, application_form: applicationform_3, status: "Rejected")
        application_pets_6 = ApplicationPet.create(pet: pet_2, application_form: applicationform_1, status: "Approved")
        application_pets_7 = ApplicationPet.create(pet: pet_3, application_form: applicationform_3)
        application_pets_8 = ApplicationPet.create(pet: pet_3, application_form: applicationform_1, status: "Rejected")
        application_pets_9 = ApplicationPet.create(pet: pet_3, application_form: applicationform_2, status: "Approved")

        expect(pet_1.application_status(applicationform_1)).to eq(nil) # no application_pets status
        expect(pet_1.application_status(applicationform_2)).to eq("Rejected") # rejected status
        expect(pet_1.application_status(applicationform_3)).to eq("Approved") # approved status
        expect(pet_1.application_status(applicationform_5)).to eq(nil) # no animals added to application_pets

        expect(pet_2.application_status(applicationform_1)).to eq("Approved") # approved status
        expect(pet_2.application_status(applicationform_2)).to eq(nil) # no application_pets status
        expect(pet_2.application_status(applicationform_3)).to eq("Rejected") # rejected status
        expect(pet_2.application_status(applicationform_5)).to eq(nil) # no animals added to application_pets

        expect(pet_3.application_status(applicationform_1)).to eq("Rejected") # rejected status
        expect(pet_3.application_status(applicationform_2)).to eq("Approved") # approved status
        expect(pet_3.application_status(applicationform_3)).to eq(nil) # no application_pets status
        expect(pet_3.application_status(applicationform_5)).to eq(nil) # no animals added to application_pets
      end
    end
  end
end
