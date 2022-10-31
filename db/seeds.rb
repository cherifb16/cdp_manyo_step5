# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

general_user = User.create!(
  name: "一般ユーザ",
  email: "general@user.com",
  password: "password",
  password_confirmation: "password",
  admin: false,
)

admin_user = User.create!(
  name: "管理者ユーザ",
  email: "admin@user.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
)

Task.create!(
  title: 'first_task',
  content: 'ごはんを炊く',
  deadline_on: Date.today,
  priority: 'high',
  status: 'done',
  user_id: general_user.id,
)

Task.create!(
  title: 'second_task',
  content: '梅干しを買う',
  deadline_on: Date.today.since(1.day),
  priority: 'middle',
  status: 'doing',
  user_id: general_user.id,
)

Task.create!(
  title: 'third_task',
  content: 'おにぎりを作る',
  deadline_on: Date.today.since(2.day),
  priority: 'low',
  status: 'todo',
  user_id: general_user.id,
)

50.times do |i|
  Task.find_or_create_by!(
    title: "UserTask#{i+1}",
    content: "腹筋#{i*100}回",
    deadline_on: Date.today.since(3.day),
    priority: 'low',
    status: 'todo',
    user_id: general_user.id,
  )
end

50.times do |i|
  Task.find_or_create_by!(
    title: "AdminTask#{i+1}",
    content: "スクワット#{i*100}回",
    deadline_on: Date.today.since(3.day),
    priority: 'low',
    status: 'todo',
    user_id: admin_user.id,
  )
end