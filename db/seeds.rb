
# Clear existing data
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Review.destroy_all
Customer.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all
User.destroy_all

puts "Creating provinces..."
provinces_data = [
  { name: 'Alberta', code: 'AB', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'British Columbia', code: 'BC', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'Manitoba', code: 'MB', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'New Brunswick', code: 'NB', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Northwest Territories', code: 'NT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Nova Scotia', code: 'NS', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Nunavut', code: 'NU', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Ontario', code: 'ON', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 13.0 },
  { name: 'Prince Edward Island', code: 'PE', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Quebec', code: 'QC', gst_rate: 5.0, pst_rate: 9.975, hst_rate: 0.0 },
  { name: 'Saskatchewan', code: 'SK', gst_rate: 5.0, pst_rate: 6.0, hst_rate: 0.0 },
  { name: 'Yukon', code: 'YT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  Province.create!(province_data)
end

puts "Creating admin user..."
admin = User.create!(
  email: 'admin@launderinglaundry.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin
)

puts "Creating categories..."
categories = [
  { name: 'T-Shirts', description: 'Comfortable cotton t-shirts for everyday wear' },
  { name: 'Dress Shirts', description: 'Professional dress shirts for formal occasions' },
  { name: 'Jeans', description: 'Durable denim jeans in various styles' },
  { name: 'Jackets', description: 'Stylish jackets for all seasons' }
]

created_categories = categories.map { |cat| Category.create!(cat) }

puts "Creating 100+ products..."
garment_types = {
  'T-Shirts' => ['Classic Cotton Tee', 'V-Neck Tee', 'Polo Shirt', 'Graphic Tee', 'Long Sleeve Tee'],
  'Dress Shirts' => ['Oxford Dress Shirt', 'Slim Fit Dress Shirt', 'Linen Dress Shirt', 'French Cuff Shirt'],
  'Jeans' => ['Slim Fit Jeans', 'Straight Leg Jeans', 'Bootcut Jeans', 'Skinny Jeans', 'Relaxed Fit Jeans'],
  'Jackets' => ['Denim Jacket', 'Leather Jacket', 'Bomber Jacket', 'Windbreaker', 'Parka']
}

colors = ['Black', 'White', 'Navy', 'Gray', 'Blue', 'Red', 'Green', 'Burgundy', 'Khaki', 'Charcoal']
sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL']

created_categories.each do |category|
  types = garment_types[category.name] || ['Item']

  25.times do |i|
    type = types.sample
    color = colors.sample
    size = sizes.sample

    Product.create!(
      name: "#{color} #{type} - #{size}",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      price: rand(19.99..149.99).round(2),
      sale_price: rand > 0.7 ? rand(14.99..99.99).round(2) : nil,
      on_sale: rand > 0.7,
      sku: "LLL-#{category.name[0..2].upcase}-#{SecureRandom.hex(4).upcase}",
      stock_quantity: rand(0..100),
      category: category
    )
  end
end

puts "Seed completed!"
puts "Created #{Province.count} provinces"
puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
puts "Admin login: admin@launderinglaundry.com / password123"
