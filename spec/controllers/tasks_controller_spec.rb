require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:member) { create(:user, :member) }
  let(:task) { create(:task, created_by: admin) }
  
  before do
    @current_user = admin
    # allow(controller).to receive(:current_user).and_return(admin) # or member based on the test context
    allow(controller).to receive(:authorize_admin).and_return(true)
    # allow(controller).to receive(:authorize_request).and_return(true)
    allow(controller).to receive(:set_current_user).and_return(admin) # Mock current user as admin
  end

  describe 'POST #assign_task' do
    context 'when assigning task to a member' do
      it 'assigns the task successfully' do
        post :assign_task, params: { id: task.id, user_id: member.id }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Task assigned successfully')
      end
    end

    context 'when user is not found' do
      it 'returns a not found error' do
        post :assign_task, params: { id: task.id, user_id: 9999 } # Non-existent user ID

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end
    end

    context 'when assigning task to a non-member' do
      it 'returns a forbidden error' do
        post :assign_task, params: { id: task.id, user_id: admin.id }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You can only assign tasks to members')
      end
    end
  end

  describe 'GET #assigned_tasks' do
    before do
      allow(controller).to receive(:set_current_user).and_return(member) # Mock current user as member
      member.tasks << task
    end

    it 'returns tasks assigned to the current user' do
      get :assigned_tasks

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first['id']).to eq(task.id)
    end
  end

  describe 'PATCH #complete_task' do
    before do
      allow(controller).to receive(:set_current_user).and_return(member)
      member.tasks << task
    end

    context 'when the current user is assigned to the task' do
      it 'marks the task as completed' do
        patch :complete_task, params: { id: task.id }

        expect(response).to have_http_status(:ok)
        expect(Task.find(task.id).completed).to be_truthy
      end
    end

    context 'when the current user is not assigned to the task' do
      let(:other_member) { create(:user, :member) }

      it 'returns a forbidden error' do
        allow(controller).to receive(:set_current_user).and_return(other_member)

        patch :complete_task, params: { id: task.id }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not assigned to this task')
      end
    end
  end

  describe 'POST #create' do
    context 'when the current user is an admin' do
      it 'creates a task successfully' do
        post :create, params: { task: { title: 'New Task', description: 'Task description' } }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('New Task')
      end
    end

    context 'when task creation fails' do
      it 'returns an unprocessable entity status' do
        post :create, params: { task: { title: '', description: 'Task description' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include("Title can't be blank")
      end
    end
  end
end
