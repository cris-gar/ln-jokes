class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index; end

  def show
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      redirect_to :edit
    end
  end

  private

  def set_user
    @user = User.find(Current.user.id)
  end

  def user_params
    params.require(:user).permit(:username)
  end
end
