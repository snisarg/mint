require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get data_push" do
    get :data_push
    assert_response :success
  end

end
