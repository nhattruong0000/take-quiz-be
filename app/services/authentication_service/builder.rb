module AuthenticationService
  module Builder
    def self.build_jwt_token(user, valid_for_minutes = Rails.configuration.x.oauth.default_exp)
      exp = Time.now.to_i + (valid_for_minutes)
      payload = { "iss": Rails.application.credentials.jwt_auth.iss,
                  "exp": exp,
                  "aud": Rails.application.credentials.jwt_auth.aud,
                  "user": _serialize_user(user) }
      JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
    end

    def self.verify_jwt_token(token)
      return 0 unless token
      begin
        decoded_token = JWT.decode token,
                                   Rails.application.secrets.secret_key_base,
                                   true,
                                   { verify_iss: true,
                                     iss: Rails.application.credentials.jwt_auth.iss,
                                     verify_aud: true,
                                     aud: Rails.application.credentials.jwt_auth.aud,
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
end
