require 'rails_helper'

feature "I want to see a list of past mentorships", focus: true do
  let(:user) { create :user, :not_on_waitlist }
  let!(:mentorship1) { create :mentorship, mentee: user }
  let!(:mentorship2) { create :mentorship, mentor: user }

  before do
    login_as(user, :scope => :user)
  end

  scenario "On my profile page, there is a link to my mentorship history" do
    visit user_path(user)

    expect(page).to have_selector(:link_or_button, 'Mentorship History')
  end

  scenario "I should have a list of past mentorships" do
    visit user_path(user)

    click_on "Mentorship History"

    within '.row', text: mentorship1.mentor.full_name do
      expect(page).to have_content mentorship1.mentor.full_name
      expect(page).to have_content user.full_name
      expect(page).to have_content I18n.l(mentorship1.created_at, format: :default)
      expect(page).to have_content mentorship1.question
    end

    within '.row', text: mentorship2.mentee.full_name do
      expect(page).to have_content mentorship2.mentee.full_name
      expect(page).to have_content user.full_name
      expect(page).to have_content I18n.l(mentorship2.created_at, format: :default)
      expect(page).to have_content mentorship2.question
    end
  end
end
