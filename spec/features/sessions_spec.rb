require "rails_helper"

RSpec.describe 'Session' do
  scenario 'Sign in and out' do
    user = FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com')

    visit sign_in_path
    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password
    click_button 'Sign in'

    expect(page).to have_content 'welcome to Ruby Australia'
    expect(page).to have_content user.preferred_name

    click_link 'Sign out'

    expect(page).to have_content 'You are now logged out.'
    expect(page).to_not have_content user.preferred_name
  end

  scenario 'Unconfirmed account' do
    user = FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com', email_confirmed: false)

    visit sign_in_path
    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password
    click_button 'Sign in'

    expect(page).to have_content(
      'You have not yet confirmed your email address.'
    )
  end

  scenario 'Invalid credentials' do
    visit sign_in_path
    fill_in "session_email", with: 'invalid@email.com'
    fill_in "session_password", with: 'randopassword'
    click_button 'Sign in'

    expect(page).to have_content 'Invalid email or password'
  end
end
