
namespace :prod do
  desc "Configura ambiente de produção"
  task setup: :environment do
    puts "Creating users"
    1.times do |i|
      attributes = {
        "name": 'Admin',
        "email": 'admin@admin.com',
        "password": "123456",
        "gender": ["M", "F", "O"].sample,
        "phone": '83999999999',
        "admin": true,
        "document": CPF.generate,
        "birthday": Time.now
      }
      user = User.new(attributes)
      user.skip_confirmation!
      user.save!
    end
    puts "Finished creating users"
    puts "Creating categories"
    [0, 1, 2, 3].each do |i|
      Category.create!(
        name: i
      )
    end
    puts "Finished creating cattegories"
  end
end
