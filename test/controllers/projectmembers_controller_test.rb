require "test_helper"

class ProjectmembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get projectmembers_index_url
    assert_response :success
  end

  test "should get create" do
    get projectmembers_create_url
    assert_response :success
  end
end
