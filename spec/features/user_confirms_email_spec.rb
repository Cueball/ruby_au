require "rails_helper"

RSpec.feature "User confirms account", type: :feature do
  let(:user) { create :user, confirmed_at: nil }

  before :each do
    ActionMailer::Base.deliveries.clear
  end

  scenario "by clicking the link in an email" do
    stub_request(
      :get, %r{https://api.createsend.com/api/v3.2/subscribers/camp-key.json}
    ).and_return(
      body: JSON.dump("State" => "Active"),
      headers: { "Content-Type" => "application/json" }
    )

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.2/subscribers/conf-key.json}
    ).and_return(
      body: JSON.dump("State" => "Unsubscribed"),
      headers: { "Content-Type" => "application/json" }
    )

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.2/subscribers/girls-key.json}
    ).and_return(
      status: 400,
      body: JSON.dump("Code" => 203, "Message" => "Subscriber not in list"),
      headers: { "Content-Type" => "application/json" }
    )

    user

    email = emails_sent_to(user.email).detect do |mail|
      mail.subject == "Confirmation instructions"
    end
    expect(email).to be_present

    email.click_link 'Confirm my membership'

    expect(page).to have_content("Your email address has been successfully confirmed.")

    user.reload
    expect(user.memberships.current.count).to eq(1)
    expect(user.mailing_lists["Rails Camp"]).to eq("true")
    expect(user.mailing_lists["RubyConf AU"]).to eq("false")
    expect(user.mailing_lists["RailsGirls"]).to eq("false")
  end
end
