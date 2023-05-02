module StudyService
  module Validator
    def self.check_study_card_authorized(study_card, current_user)
      #study_card already have submitted
      if study_card&.status == 'submitted'
        return [false, 'Study card already have submitted']
      end

      #study session still acitve
      session_authorized = study_card&.study_session&.status == 'active'
      #same user
      user_authorized = study_card&.card&.user == current_user
      session_authorized && user_authorized
      if session_authorized && user_authorized
        return [true, nil]
      else
        return [false, "You aren't authorized on study card"]
      end
    end
  end
end
