module CardCollectionService
  module Serializer
    def self.card_collection(data)
      data.as_json()
    end

    def self.card_collection_with_cards(data)
      data.as_json(
        include: [
          cards: { except: [:created_at, :updated_at] },
        ]
      )
    end

    def self.card(data)
      data.as_json()
    end

  end
end
