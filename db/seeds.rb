# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
category_names = ["书籍", "商务", "设计创意", "教育培训", "娱乐生活", "金融财务", "游戏", "健康养生", "DIY", "摄影摄像", "编程", "研究调研", "科学技术", "旅游"]
category_names.each do |category_name|
  Category.create! name: category_name
end
