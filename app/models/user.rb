class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  before_validation { email.downcase! }
  before_update :check_admin_exist_for_update
  before_destroy :check_admin_exist_for_destroy

  def admin?
    admin
  end

  private
    def check_admin_exist_for_update
      if self.is_only_one_admin? && self.will_save_change_to_attribute?(:admin)
        errors.add(:base, "管理者権限を持つアカウントが0件になるため更新できません")
        throw(:abort)
      end 
    end

    def check_admin_exist_for_destroy
      throw(:abort) if self.is_only_one_admin?
    end

    def is_only_one_admin?
      User.where(admin: true).count == 1 && self == User.find_by(admin: true)
    end
end