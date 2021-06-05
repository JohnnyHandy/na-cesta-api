namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  # def purge_attachments
  #   attachments = ActiveStorage::Attachment.all
  #   attachments.each { |attachment| attachment.purge } if attachments.length > 0
  # end
  task purge_files: :environment do
    puts "Purging files"
    attachments = ActiveStorage::Attachment.all
    attachments.each { |attachment| attachment.purge } if attachments.length > 0
  end
  task setup: :environment do
    # purge_attachments
    puts "Creating users"
    10.times do |i|
      attributes = {
        "name": Faker::Name.name,
        "email": Faker::Internet.unique.email,
        "password": "123456",
        "genre": ["M", "F", "O"].sample,
       "phone": Faker::PhoneNumber.cell_phone

      }
      user = User.new(attributes)
      user.skip_confirmation!
      user.save!
    end
    1.times do |i|
      attributes = {
        "name": 'Admin',
        "email": 'admin@admin.com',
        "password": "123456",
        "genre": ["M", "F", "O"].sample,
        "phone": Faker::PhoneNumber.cell_phone,
         "admin": true
      }
      user = User.new(attributes)
      user.skip_confirmation!
      user.save!
    end
    puts "Finished creating users"
    puts "Adding addresses for users"
    User.all.where('admin': nil).each do |user|
      rand(1..3).times do |i|
        address = Address.create(
          cep: Faker::Address.zip_code,
          street: Faker::Address.street_name,
          number: Faker::Address.building_number,
          complement: Faker::Address.secondary_address,
          neighbourhood: Faker::Address.community,
          city: Faker::Address.city,
          state: Faker::Address.state,
        )
        user.addresses << address
        user.save!
      end
    end
    puts "Finished adding addresses"  
    puts "Creating categories"
    [1, 2, 3].each do |i|
      Category.create!(
        name: i
      )
    end
    puts "Finished creating cattegories"
    puts "Creating Models"
    5.times do |i|
      Model.create!(
        name: "Model #{i}",
        ref: Faker::Alphanumeric.alpha(number: 10),
        category: Category.all.sample
      )
    end
    puts "Finished creating models"
    puts "Creating products"
    sizes = ['S', 'M', 'G']
    15.times do |i|
      Product.create!(
        name: "Product #{i}",
        color: Faker::Color.hex_color,
        size: sizes.sample,
        model: Model.all.sample,
        description: "Description text #{i}",
        is_deal: [true,false].sample,
        discount: [0, rand(10..40)].sample,
        price: Faker::Number.decimal(l_digits: 2),
        deal_price: Faker::Number.decimal(l_digits: 2) ,
        in_stock: rand(0..30),
        enabled: [true,false].sample
      )
    end
    puts "Finished creating products"
    puts "Creating Images"
    images = Dir.glob(Rails.root.join('assets', '*.{jpg,gif,png}'))
    
    # imagesArray = [
    #   'https://via.placeholder.com/150',
    #   'https://via.placeholder.com/150',
    #   'https://via.placeholder.com/150'
    # ]
    Product.all.each do |product|
      rand(1..3).times do |i|
        path = images.sample
        File.open(path) do |file|
          product.images.attach(
            key: "/images/#{Faker::Alphanumeric.alpha(number: 4)}-#{File.basename(path)}",
            io: file,
            filename: "#{i}-#{File.basename(path)}",
            content_type: 'image/jpeg'
          )
        end
        product.save!
      end  
    end
    puts "Finished creating images"
    puts "Creating orders"
    5.times do |i|
      user =  User.all.where('admin': nil).sample
      Order.create!(
        status: [0, 1, 2].sample,
        discount: rand(20..40),
        coupon: 'code',
        total: 0,
        user: user,
        address: user.addresses.sample
      )
    end
    puts "Finished creating orders"
    puts "Creating order_items"
    Order.all.each do |order|
      totalPrice = 0
      rand(1..5).times do |i|
        product = Product.all.sample
        quantity = rand(1..5)
        productPrice = product.discount > 0 ? product.price * (product.discount/100) : product.is_deal ? product.deal_price : product.price
        order_item = OrderItem.create!(
          name: product.name,
          product_id: product.id,
          color: product.color,
          size: product.size,
          description: product.description,
          is_deal: product.is_deal,
          discount: product.discount,
          price: product.price,
          deal_price: product.deal_price,
          quantity: quantity,
          order: Order.all.sample,
          subtotal: productPrice * quantity
        )
        totalPrice = totalPrice + (quantity * productPrice)
        order.order_items << order_item
        order.save!
      end
      order.total = totalPrice
      order.save!
    end
    puts "Finished creating order_items"
  end

end
