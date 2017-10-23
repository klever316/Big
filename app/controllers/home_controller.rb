class HomeController < ApplicationController
  def index
  	@nome_completo = Devise::LDAP::Adapter.get_ldap_param(current_user.username,"cn").first.force_encoding("utf-8")
  	puts request.env['HTTP_USER_AGENT']
  end

  def minor
  end

end

