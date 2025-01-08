require "test_helper"

class AttractionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attractions_index_url
    assert_response :success
  end
end
