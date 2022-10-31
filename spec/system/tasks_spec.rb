require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  let!(:user) { FactoryBot.create(:user) }

  describe '登録機能' do
    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end

    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "タイトル", with: "タスクタイトル"
        fill_in "内容", with: "タスク内容"
        fill_in "終了期限", with: Date.today
        select "低", from: "task[priority]"
        select "未着手", from: "task[status]"
        click_button "登録する"
        expect(page).to have_content "タスクを登録しました"
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, title: "first_task", created_at: Time.zone.now.ago(3.days), user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task", created_at: Time.zone.now.ago(2.days), user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task", created_at: Time.zone.now.ago(1.days), user: user) }

    before do
      visit new_session_path
      fill_in :session_email, with: user.email
      fill_in :session_password, with: "password"
      click_button "ログイン"
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('body tbody tr')
        expect(task_list[0]).to have_content 'third_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'first_task'
      end
    end

    context '新たにタスクを作成した場合' do
      let!(:new_task) { FactoryBot.create(:task, title: "new_task", user: user) }

      it '新しいタスクが一番上に表示される' do
        visit current_path
        task_list = all('body tbody tr')
        expect(task_list[0]).to have_content 'new_task'
      end
    end

    describe 'ソート機能' do
      context 'テーブルヘッダーの「終了期限」をクリックした際場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          click_link "終了期限"
          sleep 1.0
          task_list = all('html body tbody tr')
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context 'テーブルヘッダーの「優先度」をクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link "優先度"
          sleep 1.0
          task_list = all('html body tbody tr')
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in "タイトル", with: "first"
          click_button "検索"
          task_list = all('body tbody tr')
          expect(task_list.count).to eq 1
          expect(task_list.first).to have_content "first_task"
          expect(task_list.first).not_to have_content "second_task"
          expect(task_list.first).not_to have_content "third_task"
        end
      end

      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select "完了", from: "search[status]"
          click_button "検索"
          task_list = all('body tbody tr')
          expect(task_list.count).to eq 1
          expect(task_list.first).not_to have_content "first_task"
          expect(task_list.first).not_to have_content "second_task"
          expect(task_list.first).to have_content "third_task"
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in "タイトル", with: "first"
          select "未着手", from: "search[status]"
          click_button "検索"
          task_list = all('body tbody tr')
          expect(task_list.count).to eq 1
          expect(task_list.first).to have_content "first_task"
          expect(task_list.first).not_to have_content "second_task"
          expect(task_list.first).not_to have_content "third_task"
        end
      end

      context 'ラベルで検索をした場合' do
        let!(:label_1) { FactoryBot.create(:label, name: "ラベル１", user: user) }
        let!(:label_2) { FactoryBot.create(:label, name: "ラベル２", user: user) }
        
        before do
          first_task.labels << label_1
          second_task.labels << label_2
        end

        it "そのラベルの付いたタスクがすべて表示される" do
          visit current_path
          select label_1.name, from: "search[label_id]"
          click_button "検索"
          task_list = all('body tbody tr')
          expect(task_list.count).to eq 1
          expect(task_list.first).to have_content "first_task"
          expect(task_list.first).not_to have_content "second_task"
          expect(task_list.first).not_to have_content "third_task"
        end
      end
    end
  end

  describe '詳細表示機能' do
    before do
      visit new_session_path
      fill_in :session_email, with: user.email
      fill_in :session_password, with: "password"
      click_button "ログイン"
    end

    context '任意のタスク詳細画面に遷移した場合' do
      let(:task) { FactoryBot.create(:task, title: "書類作成", user: user) }

      it 'そのタスクの内容が表示される' do
        visit task_path(task)
        expect(page).to have_content '書類作成'
      end
    end
  end
end