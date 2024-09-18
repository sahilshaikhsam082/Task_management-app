class User < ApplicationRecord
   has_secure_password	
  
  enum role: { admin: 0, member: 1 }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
end
