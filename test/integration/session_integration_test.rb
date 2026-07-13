# test/integration/session_integration_test.rb
require "test_helper"

class SessionIntegrationTest < ActionDispatch::IntegrationTest
  test "signs in with valid credentials" do
    get new_session_url
    assert_response :success

    post session_url, params: {
      email_address: users(:alice).email_address,
      password: "password"
    }
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
  end

  test "rejects invalid password" do
    get new_session_url
    assert_response :success

    post session_url, params: {
      email_address: users(:alice).email_address,
      password: "wrong"
    }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_select "form"
  end

  test "signs out" do
    sign_in_as users(:alice)

    delete session_url
    assert_redirected_to new_session_url
  end
end
