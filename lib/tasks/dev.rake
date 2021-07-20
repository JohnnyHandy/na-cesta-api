
namespace :dev do
  Faker::Config.locale = 'pt-BR'
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
        "gender": ["M", "F", "O"].sample,
       "phone": Faker::PhoneNumber.cell_phone,
       "document": Faker::Number.number(digits: 11),
       "birthday": Faker::Date.between(from: '1980-09-23', to: '2014-09-25')

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
        "gender": ["M", "F", "O"].sample,
        "phone": Faker::PhoneNumber.cell_phone,
         "admin": true,
         "document": CPF.generate,
         "birthday": Faker::Date.between(from: '1980-09-23', to: '2014-09-25')
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
    [0, 1, 2, 3].each do |i|
      Category.create!(
        name: i
      )
    end
    puts "Finished creating cattegories"
    puts "Creating Models"
    29.times do |i|
      modelPrice = Faker::Number.decimal(l_digits: 2)
      modelDealPrice = rand(modelPrice * (0.1)... modelPrice)
      Model.create!(
        name: "Model #{i}",
        ref: Faker::Alphanumeric.alpha(number: 10),
        category: Category.all.sample,
        description: "Description text #{i}",
        is_deal: [true,false].sample,
        team: i,
        discount: [0, rand(10..40)].sample,
        price: modelPrice,
        deal_price: modelDealPrice,
        enabled: [true,false].sample
      )
    end
    puts "Finished creating models"
    puts "Creating products"
    Model.all.each do |model|
      rand(3...8).times do |i|
        nilProductInfo = [true, false].sample
        productPrice = Faker::Number.decimal(l_digits: 2)
        productDealPrice = rand(productPrice * 0.1...productPrice)
        Product.create!(
          name: "Product #{i}",
          ref: Faker::Alphanumeric.alpha(number: 10),
          color: Faker::Color.hex_color,
          model: model,
          description: nilProductInfo ? nil : "Product #{i} description",
          is_deal: nilProductInfo ? nil : [true,false].sample,
          discount: nilProductInfo ? nil : [0, rand(10..40)].sample,
          price: nilProductInfo ? nil : productPrice,
          deal_price: nilProductInfo ? nil : productDealPrice ,
          enabled: nilProductInfo ? nil : [true,false].sample
        )
      end  
    end
    puts "Finished creating products"
    puts "Creating Stocks"
    Product.all.each do |product|
      sizes = ['S', 'M', 'G']
      sizes.sample(rand(1..3)).each do |size|
        Stock.create!(
          product: product,
          quantity: rand(0...30),
          size: size
        )
      end
    end
    puts "Ended creating stocks"
    puts "Creating Images"    
    Product.all.each do |product|
      category = product.model.category.name
      if category === 'regata'
        puts 'regata'
        images = Dir.glob(Rails.root.join('assets','regata', '*.{jpg,gif,png}'))
      elsif category === 'shorts'
        puts 'shorts'
        images = Dir.glob(Rails.root.join('assets','shorts', '*.{jpg,gif,png}'))
      elsif category === 'tenis'
        puts 'tenis'
        images = Dir.glob(Rails.root.join('assets','tenis', '*.{jpg,gif,png}'))
      elsif category === 'kit'
        puts 'kit'
        images = Dir.glob(Rails.root.join('assets','kits', '*.{jpg,gif,png}'))
      end
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
        status: [0, 1, 2, 3].sample,
        payment_status: [0, 1].sample,
        payment_method: [0, 1].sample,
        boleto_pdf: '',
        discount: rand(20..40),
        ref: Faker::Alphanumeric.alpha(number: 10),
        coupon: nil,
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
        discount = product.discount || product.model.discount
        is_deal = product.is_deal || product.model.is_deal
        deal_price = product.deal_price || product.model.deal_price
        price = product.price || product.model.price
        productPrice = (is_deal && deal_price != nil) ? deal_price : (discount != nil && discount > 0 && price != nil)? (price - (price * discount/100)) : price
        order_item = OrderItem.create!(
          name: product.name,
          product_id: product.id,
          color: product.color,
          size: product.stocks.sample.size,
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
