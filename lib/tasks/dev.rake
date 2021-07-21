
namespace :dev do
  Faker::Config.locale = 'pt-BR'
  desc "Configura ambiente de desenvolvimento"
  # def purge_attachments
  #   attachments = ActiveStorage::Attachment.all
  #   attachments.each { |attachment| attachment.purge } if attachments.length > 0
  # end
  task setup: :environment do
    # purge_attachments
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
  end

end
