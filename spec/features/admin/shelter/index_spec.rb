require 'rails_helper'

RSpec.describe 'the admins shelter index' do
  it 'lists all the shelters in reverse alphabetical order' do
    # SQL Only Story
    #
    # For this story, you should write your queries in raw sql. You can use the ActiveRecord find_by_sql method to execute raw sql queries: https://guides.rubyonrails.org/active_record_querying.html#finding-by-sql
    #
    # Admin Shelters Index
    #
    # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see all Shelters in the system listed in reverse alphabetical order by name

    shelter_1 = Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: false, rank: 5)
    shelter_2 = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: true, rank: 9)
    shelter_3 = Shelter.create(name: 'Zaney Building', city: 'Chicago, IL', foster_program: true, rank: 2)

    visit "/admin/shelters"

    expect(shelter_3.name).to appear_before(shelter_2.name)
    expect(shelter_2.name).to appear_before(shelter_1.name)

  end

  it 'lists all the shelters with pending applications' do
    # For this story, you should fully leverage ActiveRecord methods in your query.
    #
    # Shelters with Pending Applications
    #
    # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see a section for "Shelter's with Pending Applications"
    # And in this section I see the name of every shelter that has a pending application

    shelter_1 = Shelter.create(name: 'Aurora Shelter', city: 'Aurora, CO', foster_program: false, rank: 5)
    shelter_2 = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: true, rank: 9)
    shelter_3 = Shelter.create(name: 'Zaney Building', city: 'Chicago, IL', foster_program: true, rank: 2)

    pet_1 = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter_1.id)
    pet_2 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter_1.id)
    pet_3 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_2.id)

    applicationform_1 = ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", description: "I'd like an animal please", status: "In Progress")
    applicationform_2 = ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "wanna animal", status: "Pending")
    applicationform_3 = ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals", status: "Accepted")
    applicationform_4 = ApplicationForm.create(name: "Michael", street_address: "621311 Thisdude Street", city: "Philadelphia", state: "PA", zip_code: "19147", description: "Definitely NOT for fighting", status: "Rejected")

    application_pets_1 = ApplicationPet.create(pet: pet_1, application_form: applicationform_2)
    application_pets_2 = ApplicationPet.create(pet: pet_3, application_form: applicationform_2)
    application_pets_3 = ApplicationPet.create(pet: pet_2, application_form: applicationform_1)

    visit "/admin/shelters"

    expect(page).to have_content("Shelter's with Pending Applications:")

    within "#pending-applications" do
      expect(page).to have_content("Aurora Shelter")
      expect(page).to have_content("Mystery Building")
      expect(page).to_not have_content("Zaney Building")
    end

    pet_4 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Melvin', shelter_id: shelter_3.id)
    application_pets_4 = ApplicationPet.create(pet: pet_4, application_form: applicationform_2)

    visit "/admin/shelters"
    within "#pending-applications" do
      expect(page).to have_content("Aurora Shelter")
      expect(page).to have_content("Zaney Building")
    end

  end
end
