require 'test_helper'

class CrimeOrganizadoControllerTest < ActionDispatch::IntegrationTest
  test "should get painel_crime" do
    get crime_organizado_painel_crime_url
    assert_response :success
  end

end
