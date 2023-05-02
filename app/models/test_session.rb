class TestSession < ApplicationRecord
  belongs_to :card_collection, class_name: 'CardCollection', foreign_key: :card_collection_id, primary_key: :id, optional: true

  has_many :test_cards, class_name: 'TestCard', dependent: :restrict_with_error, foreign_key: :test_session_id, primary_key: :id
end