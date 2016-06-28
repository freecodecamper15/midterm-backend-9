namespace :dev do

  task :demo => :environment do
    puts 'demo!'

    puts Post.count
  end

  task :fake => :environment do

    User.delete_all
    Post.delete_all
    Comment.delete_all

    puts 'creating fake data!'

    user = User.create!( :email => 'jason@gmail.com', :password => '111111')

    100.times do |i|
      e = Post.create( :title => Faker::App.name )
      100.times do |j|
        e.comments.create( :content => Faker::Name.name )
      end
    end

  end
end