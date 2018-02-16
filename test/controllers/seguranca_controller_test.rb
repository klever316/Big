require 'test_helper'

class SegurancaControllerTest < ActionDispatch::IntegrationTest
  test "should get salavitima" do
    get seguranca_salavitima_url
    assert_response :success
  end

  test "should get controleacesso" do
    get seguranca_controleacesso_url
    assert_response :success
  end

end
