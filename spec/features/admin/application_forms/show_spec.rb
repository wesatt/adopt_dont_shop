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
      visit "/admin/application_forms/#{applicationform_1.id}"

      expect(page).to have_content("ADMIN: Application for #{applicationform_1.name}")

      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to_not have_content("APPROVED")

        click_button "Approve This Pet For This Application"
      end

      expect(current_path).to eq("/admin/application_forms/#{applicationform_1.id}")

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

  describe "Rejecting a Pet for Adoption" do
    # As a visitor
    # When I visit an admin application show page ('/admin/applications/:id')
    # For every pet that the application is for, I see a button to reject the application for that specific pet
    # When I click that button
    # Then I'm taken back to the admin application show page
    # And next to the pet that I rejected, I do not see a button to approve or reject this pet
    # And instead I see an indicator next to the pet that they have been rejected
    it "has a button to reject a pet for a specific application" do
      application_pets_5 = ApplicationPet.create(pet: pet_2, application_form: applicationform_1)
      visit "/admin/application_forms/#{applicationform_1.id}"

      expect(page).to have_content("ADMIN: Application for #{applicationform_1.name}")

      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to have_button("Reject This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
        expect(page).to_not have_content("REJECTED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to have_button("Reject This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
        expect(page).to_not have_content("REJECTED")

        click_button "Reject This Pet For This Application"
      end

      expect(current_path).to eq("/admin/application_forms/#{applicationform_1.id}")

      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to have_button("Reject This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
        expect(page).to_not have_content("REJECTED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to_not have_button("Approve This Pet For This Application")
        expect(page).to_not have_button("Reject This Pet For This Application")
        expect(page).to have_content("REJECTED")
        expect(page).to_not have_content("APPROVED")
      end
    end
  end

  describe "Approved/Rejected Pets on one Application do not affect other Applications" do
    # As a visitor
    # When there are two applications in the system for the same pet
    # When I visit the admin application show page for one of the applications
    # And I approve or reject the pet for that application
    # When I visit the other application's admin show page
    # Then I do not see that the pet has been accepted or rejected for that application
    # And instead I see buttons to approve or reject the pet for this specific application
    it "has a button to reject a pet for a specific application" do
      application_pets_5 = ApplicationPet.create(pet: pet_2, application_form: applicationform_1)

      visit "/admin/application_forms/#{applicationform_1.id}"
      expect(page).to have_content("ADMIN: Application for #{applicationform_1.name}")


      within "#pet-#{pet_1.id}" do
        click_button "Approve This Pet For This Application"
      end

      within "#pet-#{pet_2.id}" do
        click_button "Reject This Pet For This Application"
      end

      # save_and_open_page

      applicationform_6 = ApplicationForm.create(name: "Kevin", street_address: "3333 Oneother Court", city: "New York", state: "NY", zip_code: "54321", description: "I love animals.", status: "Pending")

      application_pets_6 = ApplicationPet.create(pet: pet_1, application_form: applicationform_6)
      application_pets_7 = ApplicationPet.create(pet: pet_2, application_form: applicationform_6)

      visit "/admin/application_forms/#{applicationform_6.id}"
      # save_and_open_page
      expect(current_path).to eq("/admin/application_forms/#{applicationform_6.id}")
      within "#pet-#{pet_1.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to have_button("Reject This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
        expect(page).to_not have_content("REJECTED")
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_button("Approve This Pet For This Application")
        expect(page).to have_button("Reject This Pet For This Application")
        expect(page).to_not have_content("APPROVED")
        expect(page).to_not have_content("REJECTED")
      end

    end
  end

end
