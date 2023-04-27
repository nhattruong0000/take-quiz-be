class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Pagy::Backend
  include ActionController::Helpers
  include Response
  include ExceptionHandler
  # include Error::ErrorHandler
  before_action :authentication_user!
  # include ActiveStorage::SetCurrent

  helper_method :current_user
  helper_method :return_object

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

  def return_object(msg, obj)
    return { message: msg, data: obj }
  end

  def valid_token(token)
    return 0 unless token

    begin
      # decoded_token = JWT.decode token,
      #                            Rails.application.secrets.secret_key_base,
      #                            true,
      #                            { verify_iss: true,
      #                              iss: Rails.configuration.x.oauth.iss,
      #                              verify_aud: true,
      #                              aud: Rails.configuration.x.oauth.aud,
      #                              algorithm: 'HS256' }
      decoded_token = JWT.decode token,
                                 Rails.configuration.x.oauth.jwt_secret,
                                 true,
                                 { verify_iss: true,
                                   iss: Rails.configuration.x.oauth.iss,
                                   verify_aud: true,
                                   aud: Rails.configuration.x.oauth.aud,
                                   algorithm: 'HS256' }
      $current_user = User.find_by_id(decoded_token.first['user']['id'])
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
