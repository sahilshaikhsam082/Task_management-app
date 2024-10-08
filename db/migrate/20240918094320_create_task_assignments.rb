class CreateTaskAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :task_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :assigned_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
