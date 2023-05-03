module CardCollectionService
  module Validator
    def self.check_card_collection_authorized(card_collection, current_user)
      if card_collection&.user == current_user
        return [true, nil]
      else
        return [false, "You aren't authorized on card collection"]
      end
    end
  end
end
