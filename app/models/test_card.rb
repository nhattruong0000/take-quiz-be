class TestCard < ApplicationRecord

  belongs_to :card, class_name: 'Card', foreign_key: :card_id, primary_key: :id, optional: true
  belongs_to :test_session, class_name: 'TestSession', foreign_key: :test_session_id, primary_key: :id, optional: true
end