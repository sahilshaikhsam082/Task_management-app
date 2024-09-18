class User < ApplicationRecord

  has_secure_password	
  has_many :tasks, foreign_key: :created_by_id
  has_many :task_assignments
  has_many :assigned_tasks, through: :task_assignments, source: :task

  enum role: { admin: 0, member: 1 }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
end
