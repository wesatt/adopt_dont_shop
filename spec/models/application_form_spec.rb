require 'rails_helper'

RSpec.describe ApplicationForm, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_numericality_of(:zip_code) }
  end

  describe "instance methods" do
    let!(:shelter_1) { Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: true, rank: 9) }
    let!(:pet_1) { Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter_1.id) }
    let!(:applicationform_1) { ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", status: "In Progress") }
    let!(:applicationform_2) { ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "I would like an animal, please.", status: "Pending") }
    let!(:applicationform_3) { ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals.", status: "Accepted") }
    let!(:applicationform_4) { ApplicationForm.create(name: "Michael", street_address: "621311 Thisdude Street", city: "Philadelphia", state: "PA", zip_code: "19147", description: "Definitely NOT for fighting", status: "Rejected") }
    let!(:applicationform_5) { ApplicationForm.create(name: "Rutger", street_address: "5555 This Street", city: "Denver", state: "CO", zip_code: "80012", status: "In Progress") }
    before :each do
      application_pets_1 = ApplicationPet.create(pet: pet_1, application_form: applicationform_1)
      application_pets_2 = ApplicationPet.create(pet: pet_1, application_form: applicationform_2)
      application_pets_3 = ApplicationPet.create(pet: pet_1, application_form: applicationform_3)
      application_pets_4 = ApplicationPet.create(pet: pet_1, application_form: applicationform_4)
    end

    describe ".in_progress?" do
      it "returns boolean whether the application is 'In Progress' or not" do
        expect(applicationform_1.in_progress?).to eq(true)
        expect(applicationform_2.in_progress?).to eq(false)
        expect(applicationform_3.in_progress?).to eq(false)
        expect(applicationform_4.in_progress?).to eq(false)
        expect(applicationform_5.in_progress?).to eq(true)
      end
    end

    describe ".can_be_submitted?" do
      it "returns boolean whether the application can be submitted (is 'In Progress' and has pets added)" do
        expect(applicationform_1.can_be_submitted?).to eq(true)
        expect(applicationform_2.can_be_submitted?).to eq(false)
        expect(applicationform_3.can_be_submitted?).to eq(false)
        expect(applicationform_4.can_be_submitted?).to eq(false)
        expect(applicationform_5.can_be_submitted?).to eq(false)
      end
    end
  end
end
