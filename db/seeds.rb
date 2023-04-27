User.create(
  email: 'truong@takeit.vn',
  full_name: 'Nhat Truong',
  username: 'truong',
  password: '123123A@',
  role: 'sys'
)

User.create(
  email: 'anhlh@takeit.vn',
  full_name: 'Hùng Anh',
  username: 'anhlh',
  password: '123123A@',
  role: 'sys'
)

users = User.all
card_collections = []
users.each do |user|
  (1..50).each do |i|
    card_collections << CardCollection.new(
      name: Faker::Educator.subject,
      description: Faker::Educator.course_name,
      user_id: user.id
    )
  end
end
CardCollection.import card_collections

cards = []
card_collections = CardCollection.all
card_collections.each do |card_collection|
  (1..15).each do |i|
    cards << Card.new(
      question: Faker::JapaneseMedia::Naruto.character,
      answer: Faker::JapaneseMedia::Naruto.village,
      card_collection_id: card_collection.id,
      user_id: card_collection&.user&.id
    )
  end
end
Card.import cards
