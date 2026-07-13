require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  teardown do
    Capybara.reset_sessions!
  end

  def sign_in_to_ui_as(user)
    visit new_session_url

    fill_in "Enter your email address", with: user.email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"
    assert_selector "h1", text: "Recipes"
  end
end
