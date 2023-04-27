module CardCollectionService
  module Builder
    def self.create(card_collection_params, current_user)
      card_collection = CardCollection.new card_collection_params
      card_collection.user_id = current_user&.id
      return RenderUtil.render_json_obj(
        [CardCollection.create_success_message],
        CardCollectionService::Serializer.card_collection(card_collection)
      ) if card_collection.save
      raise ActiveRecord::RecordNotSaved.new card_collection.errors.full_messages
    end

    def self.update(card_collection_params, current_user, card_collection)
      card_collection.attributes = card_collection_params
      return RenderUtil.render_json_obj(
        [CardCollection.update_success_message],
        CardCollectionService::Serializer.card_collection(card_collection)
      ) if card_collection.save
      raise ActiveRecord::RecordNotSaved.new card_collection.errors.full_messages
    end

    def self.destroy(card_collection)
      return_obj = {}
      ActiveRecord::Base.transaction do
        card_collection.status = 'deleted'
        if card_collection
          cards = card_collection&.cards
          cards.update_all(status: 'deleted')
        end
        return_obj = RenderUtil.render_json_obj(
          [CardCollection.destroy_success_message],
          CardCollectionService::Serializer.card_collection_with_cards(card_collection)
        ) if card_collection.save
        return_obj
      end
      return_obj
    end
  end
end
