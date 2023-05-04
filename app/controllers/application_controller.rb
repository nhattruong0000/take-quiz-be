class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Pagy::Backend
  include ActionController::Helpers
  # include Response
  # include ExceptionHandler
  before_action :authentication_user!

  helper_method :current_user

  private

  def authentication_user!
    token = cookies.signed[:access_token] || request.headers["Authorization"]
    # head :forbidden unless token
    # head :forbidden unless valid_token(token)
    return render json: { errors: ['Unauthenticated.'] },
                  status: :unauthorized unless token
    return render json: { errors: ['Unauthenticated.'] },
                  status: :unauthorized if valid_token(token) == 0
    return render json: { errors: ['User locked.'] },
                  status: :unauthorized if valid_token(token) == 2
  end

  def current_user
    $current_user
  end

  def valid_token(token)
    return 0 unless token

    begin
      p '&&&&&&&&&&&&&&&&&&&&&&&&&'
      p Rails.application.secrets.secret_key_base
      p Rails.application.credentials.jwt_auth.iss
      p Rails.application.credentials.jwt_auth.aud
      decoded_token = JWT.decode token,
                                 Rails.application.secrets.secret_key_base,
                                 true,
                                 { verify_iss: true,
                                   iss: Rails.application.credentials.jwt_auth.iss,
                                   verify_aud: true,
                                   aud: Rails.application.credentials.jwt_auth.aud,
                                   algorithm: 'HS256' }
      p decoded_token
      $current_user = User.find_by_id(decoded_token.first['user']['id'])
      p $current_user
      return 0 unless $current_user

      # check locked
      if $current_user.locked_at
        return 2
      end

      return 1

    rescue JWT::ExpiredSignature => exp
      Rails.logger.warn "Expired token message: #{exp.to_s}"
      return 0
    rescue JWT::DecodeError => e
      Rails.logger.warn "Error decoding the JWT: #{e.to_s}"
      return 0
    end
    false
  end
end
