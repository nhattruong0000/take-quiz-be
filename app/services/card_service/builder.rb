module CardService
  module Builder
    def self.create(card_params, card_collection, current_user)
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

    def self.update(card_params, card_collection, current_user)
      card_need_to_save = []
      card_hash_by_id = card_params.map { |r| [r['id'], r] }.to_h
      cards = Card.where(id: card_params.map { |item| item[:id] })
      cards.each do |card|
        card.question = card_hash_by_id[card.id][:question]
        card.answer = card_hash_by_id[card.id][:answer]
        card_need_to_save << card
      end
      Card.transaction do
        card_need_to_save.each(&:save!)
      end
      return RenderUtil.render_json_obj(
        [Card.update_success_message],
        CardService::Serializer.card(card_need_to_save)
      )
    end

    def self.destroy(card_params, card_collection, current_user)
      cards = Card.where(id: card_params.map { |item| item[:id] })
      Card.transaction do
        cards.update_all(status: 'deleted')
      end
      return RenderUtil.render_json_obj(
        [Card.destroy_success_message],
        CardService::Serializer.card(cards)
      )
    end
  end
end