class StudySession < ApplicationRecord
  has_many :study_cards, class_name: 'StudyCard', dependent: :restrict_with_error, foreign_key: :study_session_id, primary_key: :id
end