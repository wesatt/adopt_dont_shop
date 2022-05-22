require 'rails_helper'

RSpec.describe ApplicationForm, type: :feature do
  let!(:shelter_1) { Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: false, rank: 5) }
  let!(:shelter_2) { Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: true, rank: 9) }

  let!(:pet_1) { Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter_1.id) }
  let!(:pet_2) { Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter_1.id) }
  let!(:pet_3) { Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_2.id) }

  let!(:applicationform_1) { ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", description: "I'd like an animal please", status: "In Progress") }
  let!(:applicationform_2) { ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "wanna animal", status: "Pending") }
  let!(:applicationform_3) { ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals", status: "Accepted") }
  let!(:applicationform_4) { ApplicationForm.create(name: "Michael", street_address: "621311 Thisdude Street", city: "Philadelphia", state: "PA", zip_code: "19147", description: "Definitely NOT for fighting", status: "Rejected") }
  let!(:applicationform_5) { ApplicationForm.create(name: "Rutger", street_address: "5555 This Street", city: "Denver", state: "CO", zip_code: "80012", status: "In Progress") }

  let!(:application_pets_1) { ApplicationPet.create(pet: pet_1, application_form: applicationform_1) }
  let!(:application_pets_2) { ApplicationPet.create(pet: pet_3, application_form: applicationform_2) }
  let!(:application_pets_3) { ApplicationPet.create(pet: pet_1, application_form: applicationform_2) }

  describe "Application(form) Show Page" do
    # As a visitor
    # When I visit an applications show page
    # Then I can see the following:
    # - Name of the Applicant
    # - Full Address of the Applicant including street address, city, state, and zip code
    # - Description of why the applicant says they'd be a good home for this pet(s)
    # - names of all pets that this application is for (all names of pets should be links to their show page)
    # - The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"
    it "Shows all the info of an application form and provides links to each pet for that application form" do
      visit "/application_forms/#{applicationform_2.id}/"

      expect(page).to have_content(applicationform_2.name)
      expect(page).to have_content(applicationform_2.street_address)
      expect(page).to have_content(applicationform_2.city)
      expect(page).to have_content(applicationform_2.state)
      expect(page).to have_content(applicationform_2.zip_code)
      expect(page).to have_content(applicationform_2.description)

      applicationform_2.pets.each do |pet|
        expect(page).to have_content(pet.name)
        click_link pet.name
        expect(current_path).to eq("/pets/#{pet.id}/")
        visit "/application_forms/#{applicationform_2.id}/"
      end

      expect(current_path).to eq("/application_forms/#{applicationform_2.id}/")
      expect(page).to have_content(applicationform_2.status)
    end
  end

  describe "Searching for Pets for an Application" do
    # As a visitor
    # When I visit an application's show page
    # And that application has not been submitted,
    # Then I see a section on the page to "Add a Pet to this Application"
    # In that section I see an input where I can search for Pets by name
    # When I fill in this field with a Pet's name
    # And I click submit,
    # Then I am taken back to the application show page
    # And under the search bar I see any Pet whose name matches my search
    it "Can add a pet to any application form with a status 'In Progress'" do
      visit "/application_forms/#{applicationform_2.id}/"
      expect(page).to_not have_content("Add a Pet to this Application")

      visit "/application_forms/#{applicationform_3.id}/"
      expect(page).to_not have_content("Add a Pet to this Application")

      visit "/application_forms/#{applicationform_4.id}/"
      expect(page).to_not have_content("Add a Pet to this Application")

      visit "/application_forms/#{applicationform_1.id}/"
      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Lobster")

      fill_in(:query, with: 'Lobster')
      click_button('Submit Search')

      expect(current_path).to eq("/application_forms/#{applicationform_1.id}/")
      expect(page).to have_content("Lobster")
    end
  end

  describe "Add a Pet to an Application" do
    # As a visitor
    # When I visit an application's show page
    # And I search for a Pet by name
    # And I see the names Pets that match my search
    # Then next to each Pet's name I see a button to "Adopt this Pet"
    # When I click one of these buttons
    # Then I am taken back to the application show page
    # And I see the Pet I want to adopt listed on this application
    it "can add a pet to an application" do
      visit "/application_forms/#{applicationform_1.id}/"
      fill_in(:query, with: 'Lobster')
      click_button('Submit Search')

      within "#current-pets" do
        expect(page).to_not have_content("Lobster")
      end

      click_button "Adopt Lobster"

      expect(current_path).to eq("/application_forms/#{applicationform_1.id}/")

      within "#current-pets" do
        expect(page).to have_content("Lobster")
      end
    end
  end

  describe "Submit an Application" do
    # As a visitor
    # When I visit an application's show page
    # And I have added one or more pets to the application
    # Then I see a section to submit my application
    # And in that section I see an input to enter why I would make a good owner for these pet(s)
    # When I fill in that input
    # And I click a button to submit this application
    # Then I am taken back to the application's show page
    # And I see an indicator that the application is "Pending"
    # And I see all the pets that I want to adopt
    # And I do not see a section to add more pets to this application
    it "can submit an application if there is an animal added and a description" do
      visit "/application_forms/#{applicationform_5.id}/"

      expect(page).to_not have_content("Why would you be a good owner for your selected pet(s)?")
      within "#current-pets" do
        expect(page).to_not have_content("Lobster")
      end

      fill_in(:query, with: "Lobster")
      click_button("Submit Search")
      click_button("Adopt Lobster")

      expect(page).to have_content("Application Status: In Progress")
      expect(page).to have_content("Why would you be a good owner for your selected pet(s)?")
      expect(page).to have_content("Add a Pet to this Application")

      click_button("Submit Application")

      expect(page).to have_content("Error: Description cannot be blank.")

      fill_in(:description, with: "I'm gonna love this animal with all my heart!")
      click_button("Submit Application")

      expect(current_path).to eq("/application_forms/#{applicationform_5.id}/")
      within "#current-pets" do
        expect(page).to have_content("Lobster")
      end
      expect(page).to have_content("Application Status: Pending")
      expect(page).to have_content("I'm gonna love this animal with all my heart!")
      expect(page).to_not have_content("Why would you be a good owner for your selected pet(s)?")
      expect(page).to_not have_content("Add a Pet to this Application")
    end
  end
end
