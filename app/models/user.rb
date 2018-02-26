class User < UserDB
  #Constants
  ROLES = {:full_access => 0, :restricted_access => 1}

  #Enums
  enum role: ROLES

  #Scopes
  scope :with_full_access, -> { where(role: ROLES[:full_access]) }
  scope :with_restricted_access, -> { where(role: ROLES[:restricted_access]) }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true
  before_validation :get_ldap_save
  
  def get_ldap_save
    # if Devise::LDAP::Adapter.get_ldap_param(username, 'mail') 
  	 self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
    # else
      # self.email = "#{username}@tjce.jus.br"
    # end
  end
# hack for remember_token
def authenticatable_token
	Digest::SHA1.hexdigest(email)[0,29]
end

end
