class CardCollection < ApplicationRecord
  has_many :cards, class_name: 'Card', dependent: :restrict_with_error, foreign_key: :card_collection_id, primary_key: :id

  belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id, optional: true

end