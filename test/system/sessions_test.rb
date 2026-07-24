# test/system/sessions_test.rb
require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "signs in and out of the app" do
    visit new_session_url
    fill_in "Enter your email address", with: users(:alice).email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"

    assert_selector "h1", text: "Recipes"
    assert_text "Sign out"

    click_on "Sign out"
    refute_selector "h1", text: "Recipes"
    assert_button "Sign in"
  end
end
