module CardService
  module Builder
    def self.create(card_params, card_collection, current_user)
      ap card_collection
      cards = []
      card_params.each { |card| cards << Card.new(question: card[:question], answer: card[:answer], user_id: current_user.id, card_collection_id: card_collection.id)}
      Card.transaction do
        cards.each(&:save!)
      end
      return RenderUtil.render_json_obj(
        [Card.create_success_message],
        CardService::Serializer.card(cards)
      )
    end

    def self.update(card_params, current_user)
      #TODO: create card
    end
  end
end