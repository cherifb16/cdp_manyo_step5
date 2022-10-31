require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in "名前", with: "user"
        fill_in "メールアドレス", with: "user@user.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        click_button "登録する"
        expect(page).to have_content "アカウントを登録しました"
        expect(page).to have_content "タスク一覧ページ"
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content "ログインしてください"
        expect(page).to have_content "ログインページ"
      end
    end
  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }

    context '登録済みのユーザでログインした場合' do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content "ログインしました"
        expect(page).to have_content "タスク一覧ページ"
      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(page).to have_content "アカウント詳細ページ"
        expect(page).to have_content user.name
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(another_user)
        expect(page).to have_content "本人以外アクセスできません"
        expect(page).to have_content "タスク一覧ページ"
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link "ログアウト"
        expect(page).to have_content "ログアウトしました"
        expect(page).to have_content "ログインページ"
      end
    end
  end

  describe '管理者機能' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:user) { FactoryBot.create(:user) }

    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: admin_user.email
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content "ユーザ一覧ページ"
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in "名前", with: "user"
        fill_in "メールアドレス", with: "user@user.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        click_button "登録する"
        expect(page).to have_content "ユーザを登録しました"
        expect(page).to have_content "ユーザ一覧ページ"
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(page).to have_content "ユーザ詳細ページ"
        expect(page).to have_content user.name
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user)
        expect(page).to have_content "ユーザ編集ページ"
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        find("a[data-destroy_user='#{user.id}']").click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ユーザを削除しました'
        expect(page).to have_content "ユーザ一覧ページ"
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it 'タスク一覧画面に遷移し、「管理者以外はアクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外はアクセスできません'
        expect(page).to have_content "タスク一覧ページ"
      end
    end
  end
end