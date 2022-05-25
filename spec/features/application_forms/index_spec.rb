require 'rails_helper'

RSpec.describe 'the application form index' do
  it 'lists all the application forms with links to their application show page' do
    applicationform_1 = ApplicationForm.create(name: "Hank", street_address: "1234 Some Street", city: "Aurora", state: "CO", zip_code: "80015", description: "I'd like an animal please", status: "In Progress")
    applicationform_2 = ApplicationForm.create(name: "Levi", street_address: "4321 Another Street", city: "Los Angeles", state: "CA", zip_code: "12345", description: "wanna animal", status: "Pending")
    applicationform_3 = ApplicationForm.create(name: "Diana", street_address: "4444 Oneother Court", city: "Detroit", state: "MI", zip_code: "54321", description: "I love animals", status: "Accepted")
    applicationform_4 = ApplicationForm.create(name: "Michael", street_address: "621311 Thisdude Street", city: "Philadelphia", state: "PA", zip_code: "19147", description: "Definitely NOT for fighting", status: "Rejected")

    visit "/application_forms"


    expect(page).to have_content(applicationform_1.name)
    expect(page).to have_content(applicationform_2.name)
    expect(page).to have_content(applicationform_3.name)
    expect(page).to have_content(applicationform_4.name)

    click_link("View #{applicationform_1.name}'s Application")
    expect(current_path).to eq("/application_forms/#{applicationform_1.id}")
  end
end
