require 'rails_helper'

 RSpec.describe 'ラベルモデル機能', type: :model do

  let!(:user) { FactoryBot.create(:user) }

   describe 'バリデーションのテスト' do
     context 'ラベルの名前が空文字の場合' do
       it 'バリデーションに失敗する' do
        label = Label.create(
          name: "",
          user_id: user.id,
        )
        expect(label).not_to be_valid
      end
     end

     context 'ラベルの名前に値があった場合' do
       it 'バリデーションに成功する' do
        label = Label.create(
          name: "ラベル",
          user_id: user.id,
        )
        expect(label).to be_valid
       end
     end
   end
 end