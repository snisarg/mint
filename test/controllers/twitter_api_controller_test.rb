require 'test_helper'

class TwitterApiControllerTest < ActionController::TestCase
  test "should get fetch_tweets" do
    get :fetch_tweets
    assert_response :success
  end

end
