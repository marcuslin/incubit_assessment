class SessionsController < ApplicationController
  def new
    redirect_to edit_user_path(session[:user]) if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user] = user.id
      redirect_to edit_user_path(user.id), notice: "Welcome back! #{ user.name }"
    else
      flash[:error] = "Invalid Email or Password"
      render :new
    end
  end

  def destroy
    session[:user] = ''
    redirect_to root_path, notice: "Bye!!"
  end
end
