# spec/factories/task_assignments.rb
FactoryBot.define do
  factory :task_assignment do
    association :task
    association :user
    assigned_by { create(:user, :admin) }
  end
end
