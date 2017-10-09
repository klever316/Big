class HomeController < ApplicationController
  def index
  	@nome_completo = Devise::LDAP::Adapter.get_ldap_param(current_user.username,"cn").first
  end

  def minor
  end

end

