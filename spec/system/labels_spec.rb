require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end

    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in "名前", with: "ラベル"
        click_button "登録する"
        expect(page).to have_content "ラベルを登録しました"
        expect(page).to have_content "ラベル一覧ページ"
      end
    end
  end

  describe '一覧表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:label_1) { FactoryBot.create(:label, name: "ラベル１", user: user) }
    let!(:label_2) { FactoryBot.create(:label, name: "ラベル２", user: user) }

    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        expect(page).to have_content "ラベル１"
        expect(page).to have_content "ラベル２"
      end
    end
  end
end