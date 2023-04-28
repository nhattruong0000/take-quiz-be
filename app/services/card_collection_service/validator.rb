module CardCollectionService
  module Validator
    def self.check_card_collection_authorized(card_collection, current_user)
      card_collection&.user == current_user
    end
  end
end
