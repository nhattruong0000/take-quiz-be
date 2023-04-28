module StudyService
  module Validator
    def self.check_study_card_authorized(study_card, current_user)
      #study session still acitve
      session_authorized = study_card&.study_session&.status == 'active'
      #same user
      user_authorized = study_card&.card&.user == current_user
      session_authorized && user_authorized
    end
  end
end
