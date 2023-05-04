module TestService
  module Serializer
    def self.test_session_with_test_cards(data)
      data.as_json(
        include: [
          test_cards: { except: [:created_at, :updated_at] },
        ]
      )
    end

    def self.test_session_with_card_collection(data)
      data.as_json(
        include: [
          card_collection: { except: [:created_at, :updated_at] },
        ]
      )
    end

  end
end
