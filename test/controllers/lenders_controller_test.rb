require 'test_helper'

class LendersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get lend" do
    get :lend
    assert_response :success
  end

end
