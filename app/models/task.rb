class Task < ApplicationRecord
  has_many :task_assignments, dependent: :destroy
  has_many :users, through: :task_assignments

  belongs_to :created_by, class_name: 'User'
end
