
---

## Setup Guide

### Prerequisites

- Ruby 3.2.2 or later
- Rails 7.0.8 or later
- PostgreSQL or other database supported by Rails
- Bundler for managing gems

### Setup Steps

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/sahilshaikhsam082/Task_management-app.git
   cd Task_management-app
   ```

2. **Install Dependencies:**

   ```bash
   bundle install
   ```

3. **Setup the Database:**

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Seed the Database (optional):**

   If you have seed data:

   ```bash
   rails db:seed
   ```

5. **Start the Rails Server:**

   ```bash
   rails server
   ```

6. **Run Tests:**

   To ensure everything is working correctly:

   ```bash
   bundle exec rspec
   ```

7. **Access the API:**

   - **Register User:** `POST /api/register`
   - **Login User:** `POST /api/login`
   - **Create Task (Admin Only):** `POST /api/tasks`
   - **Assign Task (Admin Only):** `POST /api/tasks/:id/assign`
   - **List Assigned Tasks (Member):** `GET /api/tasks/assigned`
   - **Complete Task (Member):** `PATCH /api/tasks/:id/complete`

### Configuration

- Update environment variables for database configuration and JWT secrets in `config/application.yml` or `.env`.

---

This should help you get the project up and running quickly.

