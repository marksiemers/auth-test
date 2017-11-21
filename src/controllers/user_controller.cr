class UserController < ApplicationController
  @current_user : User?
  before_action do
    all { set_current_user }
  end

  def show
    render("show.slang") if (user = @current_user)
  end

  def edit
    render("edit.slang") if (user = @current_user)
  end

  def update
    user = @current_user
    if update_user(user)
      flash[:success] = "Updated Profile successfully."
      redirect_to "/profile"
    elsif user
      flash[:danger] = "Could not update Profile!"
      render("edit.slang")
    end
  end

  private def update_user(user)
    return false unless user && user_params.valid?
    user.set_attributes(user_params.to_h)
    user.valid? && user.save
  end

  private def user_params
    params.validation do
      required(:email) {|f| !f.nil? && !f.empty? }
      optional(:password) {|f| !f.nil? && !f.empty? }
    end
  end

  private def set_current_user
    unless (@current_user = context.current_user)
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end
end
