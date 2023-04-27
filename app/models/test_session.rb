class TestSession < ApplicationRecord
  has_many :test_cards, class_name: 'TestCard', dependent: :restrict_with_error, foreign_key: :test_session_id, primary_key: :id
end