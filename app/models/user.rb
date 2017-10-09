class User < UserDB
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true
  before_validation :get_ldap_save
  
  def get_ldap_save
  	self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
  end
# hack for remember_token
def authenticatable_token
	Digest::SHA1.hexdigest(email)[0,29]
end

end
