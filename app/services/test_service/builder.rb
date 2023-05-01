module TestService
  module Builder
    def self.generate_test_session(test_params, card_collection, current_user)
      authorized = CardCollectionService::Validator.check_card_collection_authorized(card_collection, current_user)
      return RenderUtil.render_json_obj("You aren't authorized on card collection") unless authorized

      test_params = QuestionService::Util.default_configs(test_params)

      test_cards = []
      test_session = nil
      ActiveRecord::Base.transaction do
        #create test_session
        test_session = TestSession.create(
          configs: test_params[:configs],
          card_collection_id: card_collection.id,
          )
        number_of_question = test_params[:configs][:question_count]
        cards = card_collection.cards.sample(number_of_question)
        questions = QuestionService::Builder.question_generator(cards, test_params)
        cards.each do |card|
          test_cards << TestCard.new(
            card_id: card.id,
            test_session_id: test_session.id,
            question_type: questions[card.id][:question_type],
            questions: questions[card.id][:questions],
            answers: questions[card.id][:answers],
            results: questions[card.id][:results]
          )
        end

        TestCard.transaction do
          test_cards.each(&:save!)
        end
      end
      return RenderUtil.render_json_obj(
        [TestSession.create_success_message],
        {
          test_session:test_session,
          test_cards: test_cards
        }
      )
    end

    def self.update_test_card_by_user_response(test_card_params, test_card, current_user)
      #check authorized
      authorized = TestService::Validator.check_test_card_authorized(test_card, current_user)
      return RenderUtil.render_json_obj("You aren't authorized on test card") unless authorized
      # update user result
      test_card&.results[:user_answers] = test_card_params[:user_answers]
      test_card&.results[:answered] = true
      test_card&.results[:success] = test_card_params[:user_answers]&.sort == test_card&.results['result_list']&.sort
      test_card.save!
      return RenderUtil.render_json_obj(
        [TestCard.update_success_message],
        test_card
      )
    end

  end
end