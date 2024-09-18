class ApplicationController < ActionController::Base
	
 before_action :authenticate_request

  def authenticate_request
    header = request.headers['Authorization']
    render json: {error: "token not available"} if header.nil?
    header = header.split(' ').last if header
    decoded = decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded 
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  private

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
end
