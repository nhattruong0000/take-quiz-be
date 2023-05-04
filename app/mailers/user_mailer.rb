class UserMailer < ApplicationMailer
  def change_password
    @user = params[:user]
    mail(to: @user.email, subject: "Mật khẩu của bạn đã được thay đổi!") if @user&.email
  end

  def forgot_password
    @user = params[:user]
    mail(to: @user.email, subject: "Lấy lại mật khẩu!") if @user&.email
  end

  def nofity_new_account
    @user = params[:user]
    mail(to: @user.email, subject: "Tài khoản của bạn đã được tạo!") if @user&.email
  end
end
