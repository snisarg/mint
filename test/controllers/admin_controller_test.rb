require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get DataPush" do
    get :DataPush
    assert_response :success
  end

end
