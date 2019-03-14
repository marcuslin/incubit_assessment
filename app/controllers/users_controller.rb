class UsersController < ApplicationController
  def edit
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.name = @user.email.split('@').first

    if @user.save
      redirect_to edit_user_path(@user.id), notice: 'Thank you for siging up'
    else
      flash[:error] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
