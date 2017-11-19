class UserController < ApplicationController
  def show
    if (user = context.current_user)
      render("show.slang")
    else
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end

  def edit
    if (user = context.current_user)
      render("edit.slang")
    else
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end

  def update
    if (user = context.current_user)
      update_user(user)
    else
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end

  private def update_user(user)
    user.set_attributes(user_params.to_h)
    if user.valid? && user.save
      flash[:success] = "Updated Profile successfully."
      redirect_to "/profile"
    else
      flash[:danger] = "Could not update Profile!"
      render("edit.slang")
    end
  end

  private def user_params
    params.validation do
      required(:email) {|f| !f.nil? && !f.empty? }
    end
  end
end
