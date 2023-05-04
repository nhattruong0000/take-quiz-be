class StudySession < ApplicationRecord
  belongs_to :card_collection, class_name: 'CardCollection', foreign_key: :card_collection_id, primary_key: :id, optional: true

  has_many :study_cards, class_name: 'StudyCard', dependent: :restrict_with_error, foreign_key: :study_session_id, primary_key: :id
end