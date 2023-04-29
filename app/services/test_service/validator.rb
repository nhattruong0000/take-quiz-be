module TestService
  module Validator
    def self.check_test_card_authorized(test_card, current_user)
      #test session still acitve
      session_authorized = test_card&.test_session&.status == 'active'
      #same user
      user_authorized = test_card&.card&.user == current_user
      session_authorized && user_authorized
    end
  end
end
