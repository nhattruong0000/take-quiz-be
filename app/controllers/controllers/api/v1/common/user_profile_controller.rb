class Api::V1::Common::UserProfileController < Api::V1::Common::CommonBaseController

  def show
    render json: _serialize_user_info(current_user), status: :ok
  end

  def change_password
    if _change_password_params[:new_password].length < 8
      return render json: { messages: ['Mật khẩu có độ dài ít nhất là 8 ký tự.'] },
                    status: :bad_request
    end

    if _change_password_params[:new_password] != _change_password_params[:confirm_password]
      return render json: { messages: ['Mật khẩu mới và mật khẩu xác nhận không giống nhau.'] },
                    status: :bad_request
    end

    if current_user.password != _change_password_params[:password]
      return render json: { messages: ['Sai mật khẩu.'] },
                    status: :bad_request
    end

    current_user.password = _change_password_params[:new_password]
    if current_user.save
      UserMailer.with(user: current_user).change_password.deliver_later
      return render json: { messages: ['Mật khẩu mới đã được cập nhật.'] }, status: :ok
    else
      return render json: { messages: ['Mật khẩu mới cập nhật không thành công.'] }, status: :bad_request
    end
  end

  private

  def _serialize_user_info data
    data.as_json(
      only: %i[id email full_name username role created_at updated_at]
    )
  end

  def _change_password_params
    params[:user].permit(:password, :new_password, :confirm_password)
  end



end