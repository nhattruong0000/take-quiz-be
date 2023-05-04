require 'securerandom'
# frozen_string_literal: true
# use this controller for only authentication
class AuthenticationController < ApplicationController
  before_action :authentication_user!, except: [:login, :login_token, :logout, :forgot_password, :change_password_with_token, :forgot_password_with_email]

  
  def login
    @user = User.where('lower(username) = lower(:value) OR lower(email) = :value',
                       value: _login_params[:login])
    p @user
    if @user&.size&.positive? && (@user.first.password == _login_params[:password])
      cookies.signed[:access_token] = { value: _build_jwt(@user.first), httponly: true }
      render json: _serialize_user_info(@user), status: :ok
    else
      render json: { messages: ['Thông tin đăng nhập không chính xác'] }, status: :bad_request
    end
  end


  def login_token
    @user = User.where('lower(username) = lower(:value) OR lower(email) = :value',
                       value: _login_params[:login])
    if @user&.size&.positive? && (@user.first.password == _login_params[:password])
      cookies.signed[:access_token] = { value: _build_jwt(@user.first), httponly: true }
      return_obj = { token: _build_jwt(@user.first) }
      render json: return_obj, status: :ok
    else
      render json: { messages: ['Thông tin đăng nhập không chính xác'] }, status: :bad_request
    end
  end

  def logout
    cookies.delete :access_token
    render status: :ok
  end

  def forgot_password
    #check email or something are exist on the system
    user = User.where('lower(username) = :value OR lower(email) = :value',
                      value: _forgot_password_params[:login]).first
    if user
      user.reset_password_token = SecureRandom.uuid
      UserMailer.with(user: user).forgot_password.deliver_later if user&.email && user.save!
    end

    render json: { messages: ['Nếu email này đã tồn tại trên hệ thống, xin hãy truy cập vào hộp thư email để tiếp tục quá trình lấy lại mật khẩu.'] },
           status: :ok
  end

  def forgot_password_with_email
    #check email or something are exist on the system
    user = User.where('lower(username) = lower(:value) AND lower(email) = lower(:email)',
                      value: _forgot_password_params[:login], email: _forgot_password_params[:email])&.first
    if user
      user.reset_password_token = SecureRandom.uuid
      UserMailer.with(user: user).forgot_password.deliver_later if user.save!
    else
      return render json: { messages: ['Tài khoản không tồn tại trên hệ thống hoặc bạn đã nhập sai thông tin.'] },
                    status: :bad_request
    end

    render json: { messages: ['Xin hãy truy cập vào hộp thư email để tiếp tục quá trình lấy lại mật khẩu.'] },
           status: :ok
  end

  def change_password_with_token
    user = User.find_by_reset_password_token(_change_password_with_token_params[:token])

    return render json: { messages: ['Tài khoản không tồn tại, xin hãy thực hiện lấy lại mật khẩu lần nữa.'] },
                  status: :bad_request unless user

    if _change_password_with_token_params[:new_password].length < 8
      return render json: { messages: ['Mật khẩu có độ dài ít nhất là 8 ký tự.'] },
                    status: :bad_request
    end

    if _change_password_with_token_params[:new_password] != _change_password_with_token_params[:confirm_password]
      return render json: { messages: ['Mật khẩu mới và mật khẩu xác nhận không giống nhau.'] },
                    status: :bad_request
    end

    user.password = _change_password_with_token_params[:new_password]
    user.reset_password_token = nil
    if user.save
      UserMailer.with(user: current_user).change_password.deliver_later
      return render json: { messages: ['Mật khẩu mới đã được cập nhật.'] }, status: :ok
    else
      return render json: { messages: ['Mật khẩu mới cập nhật không thành công.'] }, status: :bad_request
    end
  end

  def auth_verify
    render json: _serialize_user_info(current_user), status: :ok if current_user
    render json: { messages: ['Failed'] }, status: :forbidden unless current_user
  end

  private

  def _set_user
    @user = User.find_by_id(current_user.id)
    return render json: { messages: ['User cannot found'] }, status: :not_found if @user.blank?
  rescue StandardError => e
    return render json: { messages: ['User cannot found'] }, status: :not_found if @user.blank?
  end

  def _build_jwt(user, valid_for_minutes = Rails.configuration.x.oauth.default_exp)
    exp = Time.now.to_i + (valid_for_minutes)
    payload = { "iss": Rails.application.credentials.jwt_auth.iss,
                "exp": exp,
                "aud": Rails.application.credentials.jwt_auth.aud,
                "user": _serialize_user(user) }

    JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
  end

  def _login_params
    params[:user].permit(:login, :password, :remember)
  end

  def _forgot_password_params
    params[:user].permit(:login, :email)
  end

  def _change_password_with_token_params
    params[:user].permit(:token, :new_password, :confirm_password)
  end

  def _serialize_user data
    data.as_json(
      only: %i[id]
    )
  end

  def _serialize_user_info data
    data.as_json(
      only: %i[id email username role failed_attempts must_change_password initial_password locked_at last_sign_in_at created_at updated_at],
    )
  end
end