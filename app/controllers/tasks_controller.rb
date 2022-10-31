class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    if params[:sort_deadline_on]
      tasks = current_user.tasks.sort_deadline_on.sort_created_at
    elsif params[:sort_priority]
      tasks = current_user.tasks.sort_priority.sort_created_at
    else
      tasks = current_user.tasks.sort_created_at
    end
    
    if params[:search].present?
      tasks = tasks.search_status(params[:search][:status]) if params[:search][:status].present?
      tasks = tasks.search_title(params[:search][:title]) if params[:search][:title].present?
      tasks = tasks.search_label_id(params[:search][:label_id]) if params[:search][:label_id].present?
    end

    @tasks = tasks.page(params[:page]).per(10)
    @labels = current_user.labels.pluck(:name, :id)
  end

  def show
    current_user_required(@task.user)
  end

  def new
    @task = Task.new
    @labels = current_user.labels
  end

  def edit
    current_user_required(@task.user)
    @labels = current_user.labels
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    @task.labels << current_user.labels.where(id: params[:task][:label_ids])

    if @task.save
      redirect_to tasks_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @task.labels.clear
    @task.labels << current_user.labels.where(id: params[:task][:label_ids])

    if @task.update(task_params)
      redirect_to tasks_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('.destroyed')
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end
end
