class TasksController < ApplicationController
  before_action :authorize_admin, only: [:create]
  before_action :set_task, only: [:assign_task]
  
  def assign_task
    user = User.find_by(id: params[:user_id])
    
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end
    # Ensure the user to whom the task is being assigned is a member
    if user.member?
      task_assignment = TaskAssignment.new(task: @task, user: user, assigned_by: @current_user)
      
      if task_assignment.save
        render json: { message: 'Task assigned successfully', task_assignment: task_assignment }, status: :ok
      else
        render json: { error: task_assignment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You can only assign tasks to members' }, status: :forbidden
    end
  end

  def assigned_tasks
    tasks = @current_user.tasks

    render json: tasks, status: :ok
  end

  def complete_task
    task = Task.find(params[:id])

    # Ensure the current user is assigned to the task
    if task.users.include?(@current_user)
      task.update(completed: true)
      render json: task, status: :ok
    else
      render json: { error: 'You are not assigned to this task' }, status: :forbidden
    end
  end

  def create
    @task = @current_user.tasks.create(task_params.merge(created_by_id: @current_user.id))
    
    if @task.save
      render json: @task, status: :created
    else
      render json: { error: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
    render json: { error: 'Task not found' }, status: :not_found unless @task
  end
  
  def task_params
    params.require(:task).permit(:title, :description)
  end

  def authorize_admin
    render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.admin?
  end
end
