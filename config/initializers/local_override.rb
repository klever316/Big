# Create a new authentication strategy for Warden.  This file should go in config/initializers.
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LocalOverride < Authenticatable
      def valid?
        true
      end

      def authenticate!
        if params[:user]
          user = User.find_by_username(params[:user][:username])
          success!(user)
          # user = User.find_by_email(params[:user][:email])

          # if user && user.encrypted_password == params[:user][:password]
          #   success!(user)
          # else
          #   fail
          # end
        else
          fail
        end
      end
    end
  end
end

Warden::Strategies.add(:local_override, Devise::Strategies::LocalOverride)