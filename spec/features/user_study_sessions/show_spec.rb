# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User stats', type: :feature do
  it 'should show information about the user stats' do
    VCR.use_cassette('quote_cassette') do
      user = User.create(
        name: 'Pablo D',
        email: 'test@example.com',
        password: 'password'
      )
      user.study_sessions.create(topic: 'Ruby', duration: 5, paired: false)
      user.study_sessions.create(topic: 'Ruby', duration: 5, paired: true)
      user.study_sessions.create(topic: 'Cake', duration: 5, paired: true)
      user.study_sessions.create(topic: 'Cheese', duration: 5, paired: false)
      user.study_sessions.create(topic: 'Books', duration: 5, paired: false)
      user.study_sessions.create(topic: 'Books', duration: 5, paired: false)
      visit '/'

      click_on 'Login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_on 'Log In'

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/stats'

      expect(page).to have_content("Total time spent studying:\n00 hours and 30 minutes")
      expect(page).to have_content("Paired time spent studying:\n00 hours and 10 minutes")
      expect(page).to have_content("Web Statistics:\nYou make up 100.0% of the study time on the website")
      expect(page).to have_content("Ruby\nTime spent studying: 00 hours and 10 minutes.\nStudying while paired: 00 hours and 05 minutes.")
      expect(page).to have_content("Books\nTime spent studying: 00 hours and 10 minutes.\nStudying while paired: 00 hours and 00 minutes.")
    end
  end
end
