namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  task setup: :environment do
    puts "Creating categories"
    5.times do |i|
      Category.create!(
        name: "Category #{i}"
      )
    end
    puts "Finished creating cattegories"
    puts "Creating Models"
    3.times do |i|
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
        discount: rand(20..40),
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
  end

end
