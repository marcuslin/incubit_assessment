class ResetPasswordsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_token, only: :update
  before_action :pwd_check, only: :update

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.reset_password_sent_at = Time.now
      user.regenerate_reset_password_token

      ResetPasswordMailer.instruction(user).deliver_now

      flash[:notice] = "Reset instruction sent!"
      redirect_back(fallback_location: new_reset_password_path)
    else
      flash[:error] = "Invlalid Email Address"
      render :new
    end
  end

  def edit
    redirect_to root_url unless @user.present?
  end

  def update
    if @user.errors.any?
      flash[:error] = @user.errors.full_messages
    else
      flash[:notice] = "Password resets"
      @user.update_attributes(user_params)
    end

    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(reset_password_token: params[:token])
  end

  def valid_token
    unless (@user && @user.reset_password_sent_at < 6.hours.from_now)
      flash[:error] = "Token has expired."

      redirect_to root_path
    end
  end

  def pwd_check
    pwd = user_params[:password]
    pwd_conf =user_params[:password_confirmation]

    if pwd.blank?
      @user.errors.add(:password, "can't be empty")
    elsif pwd.length < 8
      @user.errors.add(:password, "should be more than 8 characters")
    elsif pwd_conf.blank?
      @user.errors.add(:password_confirmation, "can't be empty")
    elsif pwd_conf != pwd
      @user.errors.add(:password, "should match with Password confirmation")
    end
  end
end
