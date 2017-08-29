class UserDB < ActiveRecord::Base
    self.abstract_class = true
    establish_connection Rails.env.to_sym
end

class BigDB < ActiveRecord::Base
    self.abstract_class = true
    establish_connection :database_big
end