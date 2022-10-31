FactoryBot.define do
  factory :task do
    user
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { Date.today.since(2.day) }
    priority { 'middle' }
    status { 'todo' }
  end

  factory :second_task, class: Task do
    user
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.today.since(1.day) }
    priority { 'high' }
    status { 'doing' }
  end

  factory :third_task, class: Task do
    user
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.today }
    priority { 'low' }
    status { 'done' }
  end
end