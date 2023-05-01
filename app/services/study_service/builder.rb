module StudyService
  module Builder
    def self.generate_study_session(study_params, card_collection, current_user)
      authorized = CardCollectionService::Validator.check_card_collection_authorized(card_collection, current_user)
      return RenderUtil.render_json_obj("You aren't authorized on card collection") unless authorized

      study_params = QuestionService::Util.default_configs(study_params)

      study_cards = []
      study_session = nil
      ActiveRecord::Base.transaction do
        #create study_session
        study_session = StudySession.create(
          configs: study_params[:configs],
          card_collection_id: card_collection.id,
          )
        number_of_question = study_params[:configs][:question_count] || 5
        cards = card_collection.cards.sample(number_of_question)
        questions = QuestionService::Builder.question_generator(cards, study_params)
        cards.each do |card|
          study_cards << StudyCard.new(
            card_id: card.id,
            study_session_id: study_session.id,
            question_type: questions[card.id][:question_type],
            questions: questions[card.id][:questions],
            answers: questions[card.id][:answers],
            results: questions[card.id][:results]
          )
        end

        StudyCard.transaction do
          study_cards.each(&:save!)
        end
      end
      return RenderUtil.render_json_obj(
        [StudySession.create_success_message],
        {
          study_session:study_session,
          study_cards: study_cards
        }
      )
    end

    def self.update_study_card_by_user_response(study_card_params, study_card, current_user)
      #check authorized
      authorized = StudyService::Validator.check_study_card_authorized(study_card, current_user)
      return RenderUtil.render_json_obj("You aren't authorized on study card") unless authorized
      # update user result
      study_card&.results[:user_answers] = study_card_params[:user_answers]
      study_card&.results[:answered] = true
      study_card&.results[:success] = study_card_params[:user_answers]&.sort == study_card&.results['result_list']&.sort
      study_card.save!
      return RenderUtil.render_json_obj(
        [StudyCard.update_success_message],
        study_card
      )
    end



  end
end