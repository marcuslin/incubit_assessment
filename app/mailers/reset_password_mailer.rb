class ResetPasswordMailer < ApplicationMailer
  def instruction(user)
    @user = user
    @reset_url = edit_reset_password_url(token: @user.reset_password_token)

    mail to: @user.email
  end
end
