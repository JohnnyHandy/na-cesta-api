namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  task setup: :environment do
    puts "Creating users"
    10.times do |i|
      attributes = {
        "name": Faker::Name.unique.clear,
        "email": Faker::Internet.unique.email,
        "password": "123456",
        "genre": ["M", "F", "O"].sample
      }
      user = User.new(attributes)
      user.skip_confirmation!
      user.save!
    end
    puts "Finished creating users"
    puts "Adding addresses for users"
    User.all.each do |user|
      Random.rand(5).times do |i|
        address = Address.create(
          cep: Faker::Address.zip_code,
          street: Faker::Address.street_name,
          number: Faker::Address.building_number,
          complement: Faker::Address.secondary_address,
          neighbourhood: Faker::Address.community,
          city: Faker::Address.city,
          state: Faker::Address.state,
          phone: Faker::PhoneNumber.cell_phone
        )
        user.addresses << address
        user.save!
      end
    end
    puts "Finished adding addresses"  
    puts "Creating categories"
    [0, 1, 2].each do |i|
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
    imagesArray = [
      'https://images.pexels.com/photos/3488543/pexels-photo-3488543.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      'https://images.pexels.com/photos/789555/pexels-photo-789555.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      'https://images.pexels.com/photos/343701/pexels-photo-343701.jpeg?cs=srgb&dl=pexels-curioso-photography-343701.jpg&fm=jpg',
    ]
    Product.all.each do |product|
      Random.rand(5).times do |i|
        image = Image.create(key: imagesArray.sample)
        product.images << image
        product.save!
      end  
    end
    puts "Finished creating images"
    puts "Creating orders"
    5.times do |i|
      Order.create!(
        status: [0, 1, 2].sample,
        discount: rand(20..40),
        coupon: 'code',
        total: Faker::Number.decimal(l_digits: 2),
        user: User.all.sample
      )
    end
    puts "Finished creating orders"
    puts "Creating order_items"
    Order.all.each do |order|
      Random.rand(5).times do |i|
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
        order.order_items << order_item
        order.save!
      end  
    end
    puts "Finished creating order_items"
  end

end
