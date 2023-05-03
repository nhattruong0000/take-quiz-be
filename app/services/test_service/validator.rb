module TestService
  module Validator
    def self.check_test_card_authorized(test_card, current_user)
      # #test_card already have submitted
      # return [false, 'Test card already have submitted'] if test_card&.status == 'submitted'

      test_session = test_card&.test_session
      return [false, 'Test session does not exist'] unless test_session

      #test_session already have submitted
      return [false, 'Test session already have submitted'] if test_session&.status == 'submitted'

      #test session still acitve
      session_authorized = test_card&.test_session&.status == 'active'
      #same user
      user_authorized = test_card&.card&.user == current_user
      session_authorized && user_authorized
      if session_authorized && user_authorized
        return [true, nil]
      else
        return [false, "You aren't authorized on this test card"]
      end
    end

    def self.check_test_session_authorized(test_session, current_user)
      #test_session already have submitted
      return [false, 'Test session already have submitted'] if test_session&.status == 'submitted'

      #test session still acitve
      session_authorized = test_session&.status == 'active'
      #same user
      user_authorized = test_session&.card_collection&.user == current_user
      if session_authorized && user_authorized
        return [true, nil]
      else
        return [false, "You aren't authorized on this test session"]
      end
    end


  end
end
