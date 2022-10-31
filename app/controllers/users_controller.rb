class UsersController < ApplicationController
  before_action :already_logged_in, only: %i(new create)
  skip_before_action :login_required, only: %i(new create)
  before_action :set_user, only: %i(show edit update)

  def show
    current_user_required(@user)
  end

  def new
    @user = User.new
  end

  def edit
    current_user_required(@user)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      redirect_to tasks_path, notice: 'アカウントを登録しました'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'アカウントを更新しました'
    else
      render :edit
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
