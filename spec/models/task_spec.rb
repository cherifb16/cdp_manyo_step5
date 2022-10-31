require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do

  let!(:user) { FactoryBot.create(:user) }

  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションエラーが発生' do
        task = Task.create(
          title: '',
          content: '企画書を作成する。',
          deadline_on: Date.today,
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
        expect(task).not_to be_valid
      end
    end

    context 'タスクの内容が空文字の場合' do
      it 'バリデーションエラーが発生' do
        task = Task.create(
          title: 'タスク1',
          content: '',
          deadline_on: Date.today,
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
        expect(task).not_to be_valid
      end
    end

    context 'タスクの終了期限が空文字の場合' do
      it 'バリデーションエラーが発生' do
        task = Task.create(
          title: 'タスク1',
          content: '企画書を作成する。',
          deadline_on: '',
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
        expect(task).not_to be_valid
      end
    end

    context 'タスクの優先度が空文字の場合' do
      it 'バリデーションエラーが発生' do
        task = Task.create(
          title: 'タスク1',
          content: '企画書を作成する。',
          deadline_on: Date.today,
          priority: '',
          status: 'done',
          user_id: user.id
        )
        expect(task).not_to be_valid
      end
    end

    context 'タスクのステータスが空文字の場合' do
      it 'バリデーションエラーが発生' do
        task = Task.create(
          title: 'タスク1',
          content: '企画書を作成する。',
          deadline_on: Date.today,
          priority: 'low',
          status: '',
          user_id: user.id
        )
        expect(task).not_to be_valid
      end
    end

    context 'すべてのカラムにに値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(
          title: 'タスク1',
          content: '企画書を作成する。',
          deadline_on: Date.today,
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", user: user) }

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status('doing')).not_to include(first_task)
        expect(Task.search_status('doing')).to include(second_task)
        expect(Task.search_status('doing')).not_to include(third_task)
        expect(Task.search_status('doing').count).to eq 1
      end
    end
    
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_title('first').search_status('todo')).to include(first_task)
        expect(Task.search_title('first').search_status('todo')).not_to include(second_task)
        expect(Task.search_title('first').search_status('todo')).not_to include(third_task)
        expect(Task.search_title('first').search_status('todo').count).to eq 1
      end
    end
  end
end