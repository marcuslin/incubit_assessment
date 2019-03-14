class ResetPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.regenerate_reset_password_token
      user.reset_password_sent_at = Time.now

      flash[:notice] = "Reset instruction sent!"
      redirect_back(fallback_location: new_reset_password_path)
    else
      flash[:error] = "Invlalid Email Address"
      render :new
    end
  end
end
