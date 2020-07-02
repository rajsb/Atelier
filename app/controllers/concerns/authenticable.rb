module Authenticable
  def current_user
    return @current_user if @current_user
    
    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)
    
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Record Not Found'] }, status: :unauthorized
  rescue JWT::ExpiredSignature
    render json: { errors: ['Auth token expired'] }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { errors: ['Invalid auth token'] }, status: :unauthorized
  end
end