require 'rails_helper'

RSpec.describe "view admin_application_forms/show.html.erb", type: :feature do
  let!(:shelter_1) { Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: true, rank: 9) }
  let!(:shelter_2) { Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 5) }
  let!(:shelter_3) { Shelter.create(name: 'Best Friends', city: 'Mission Hills CA', foster_program: true, rank: 10) }

  let!(:pet_1) { Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter_1.id) }
  let!(:pet_2) { Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter_1.id) }
  let!(:pet_3) { Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_2.id) }
  let!(:pet_4) { Pet.create(adoptable: true, age: 5, breed: 'browndog', name: 'Gravy', shelter_id: shelter_2.id) }
  let!(:pet_5) { Pet.create(adoptable: true, age: 7, breed: 'pitty', name: 'David the Dog', shelter_id: shelter_2.id) }

  let!(:applicationform_1) { ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", status: "In Progress") }
  let!(:applicationform_2) { ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "I would like an animal, please.", status: "Pending") }
  let!(:applicationform_3) { ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals.", status: "Accepted") }
  let!(:applicationform_4) { ApplicationForm.create(name: "Michael", street_address: "621311 Thisdude Street", city: "Philadelphia", state: "PA", zip_code: "19147", description: "Definitely NOT for fighting", status: "Rejected") }
  let!(:applicationform_5) { ApplicationForm.create(name: "Rutger", street_address: "5555 This Street", city: "Denver", state: "CO", zip_code: "80012", status: "In Progress") }

  let!(:application_pets_1) { ApplicationPet.create(pet: pet_1, application_form: applicationform_1) }
  let!(:application_pets_2) { ApplicationPet.create(pet: pet_2, application_form: applicationform_2) }
  let!(:application_pets_3) { ApplicationPet.create(pet: pet_3, application_form: applicationform_3) }
  let!(:application_pets_4) { ApplicationPet.create(pet: pet_4, application_form: applicationform_4) }

  describe "Approving a Pet for Adoption" do
    # As a visitor
    # When I visit an admin application show page ('/admin/applications/:id')
    # For every pet that the application is for, I see a button to approve the application for that specific pet
    # When I click that button
    # Then I'm taken back to the admin application show page
    # And next to the pet that I approved, I do not see a button to approve this pet
    # And instead I see an indicator next to the pet that they have been approved
    it "has a button to approve a pet for a specific application" do
      application_pets_5 = ApplicationPet.create(pet: pet_2, application_form: applicationform_1)
      visit "/admin/applications/#{applicationform_1.id}"

      expect(page).to have_content("ADMIN: Application for #{application_form_1.name}")

      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to_not have_content("APPROVED")

        click_button "Approve This Pet For This Application"
      end

      expect(current_path).to eq("/admin/applications/#{applicationform_1.id}")

      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to_not have_button("Approve This Pet For This Application")
        expect(page).to have_content("APPROVED")
      end
    end
  end
end
