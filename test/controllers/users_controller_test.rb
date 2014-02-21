require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get Sessions" do
    get :Sessions
    assert_response :success
  end

end
