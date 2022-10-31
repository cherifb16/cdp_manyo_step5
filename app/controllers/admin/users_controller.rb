class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :admin_required

  def index
    @users = User.includes(:tasks).all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'ユーザを登録しました'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザを削除しました'
    else
      redirect_to admin_users_path, alert: '管理者権限を持つアカウントが0件になるため削除できません'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
end
