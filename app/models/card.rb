class Card < ApplicationRecord

  has_many :test_cards, class_name: 'TestCard', dependent: :restrict_with_error, foreign_key: :card_id, primary_key: :id
  has_many :study_cards, class_name: 'StudyCard', dependent: :restrict_with_error, foreign_key: :card_id, primary_key: :id

  belongs_to :card_collection, class_name: 'CardCollection', foreign_key: :card_collection_id, primary_key: :id, optional: true
  belongs_to :user, class_name: 'User', foreign_key: :user_id, primary_key: :id, optional: true
end