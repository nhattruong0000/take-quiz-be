class StudyCard < ApplicationRecord

  belongs_to :card, class_name: 'Card', foreign_key: :card_id, primary_key: :id, optional: true
  belongs_to :study_session, class_name: 'StudySession', foreign_key: :study_session_id, primary_key: :id, optional: true
end