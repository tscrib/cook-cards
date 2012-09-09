namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Make the first user an admin
    admin = User.create!(name: "Tim Scribner",
     email: "tim.scribner@gmail.com",
     password: "foobar",
     password_confirmation: "foobar")
    admin.toggle!(:admin)

    # Make the second user an admin
    admin = User.create!(name: "CarolAnne Black",
     email: "black.carolanne@gmail.com",
     password: "foobar",
     password_confirmation: "foobar")
    admin.toggle!(:admin)

    # create 99 users
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
       email: email,
       password: password,
       password_confirmation: password)
    end

    # create 50 recipes
    # But first make one that makes sense
    Recipe.create!( title: "Onion Quiche",
        directions: "1. Take out Ingredients\n2. Make the quiche",
        ingredients: "eggs, bread, milk, cinnamon",
        photo_url: "http://1.bp.blogspot.com/_sVmXW6c9FJE/ShqDlqHymuI/AAAAAAAADQA/otVS1-1UL7g/s400/creamy-quiche-lorraine.jpg")

    49.times do |n|
      title = Faker::Lorem.words
      directions = Faker::Lorem.paragraph
      ingredients = Faker::Lorem.paragraph
      # photo_url = Faker::Internet.ip_v4_address
      Recipe.create!( title: title,
        directions: directions,
        ingredients: ingredients,
        photo_url: "http://www.example-#{n}.com")
    end

    # populate the first 6 users with 50 microposts each
    # users = User.all(limit: 6)
    # 50.times do
    #   content = Faker::Lorem.sentence(5)
    #   users.each { |user| user.microposts.create!(content: content) }
    # end
  end
end