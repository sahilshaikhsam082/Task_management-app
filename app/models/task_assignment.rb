class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  belongs_to :assigned_by, class_name: 'User', optional: true
  
  validates :task_id, presence: true
  validates :user_id, presence: true
  validates :assigned_by_id, presence: true
end
