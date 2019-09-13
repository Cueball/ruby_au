require "rails_helper"

RSpec.feature "User RSVPs for an event", type: :feature do
  let(:rsvp) { create :rsvp }

  scenario "accepts via the unique link" do
    visit confirm_rsvp_path(rsvp.token)
    expect(page).to have_content("Thanks for confirming your attendance")

    rsvp.reload
    expect(rsvp.status).to eq("yes")
  end

  scenario "declines via the unique link" do
    visit decline_rsvp_path(rsvp.token)
    expect(page).to have_content("We're sorry you can't make it")

    rsvp.reload
    expect(rsvp.status).to eq("no")
  end

  scenario "changes their status" do
    visit confirm_rsvp_path(rsvp.token)
    click_link "change your status"

    expect(page).to have_content("We're sorry you can't make it")

    rsvp.reload
    expect(rsvp.status).to eq("no")
  end

  scenario "assigns a proxy" do
    visit rsvp_path(rsvp.token)

    fill_in "Your Proxy's Name", with: "Frankie Nguyen"
    click_button "Assign Proxy"

    expect(page).to have_content("your proxy representative has been recorded")
    expect(page).to have_content("Frankie Nguyen")
  end
end
