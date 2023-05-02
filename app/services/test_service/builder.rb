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
      authorized, msg = TestService::Validator.check_test_card_authorized(test_card, current_user)
      return RenderUtil.render_json_obj(msg) unless authorized
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

    def self.submit_test_cards(submit_test_params, test_session, current_user)
      authorized, msg = TestService::Validator.check_test_session_authorized(test_session, current_user)
      return RenderUtil.render_json_obj(msg) unless authorized

      # get test card id list
      test_card_hash = submit_test_params[:test_cards].map { |r| [r['test_card_id'], r] }.to_h
      test_cards = test_session&.test_cards
      total_question = test_cards.count
      total_answer = submit_test_params[:test_cards].count
      total_success_answer = 0

      test_cards.each do |test_card|
        test_card&.results[:success] = false
        if test_card_hash.has_key?(test_card.id) && test_card_hash[test_card.id].has_key?(:user_answers)
          test_card&.results[:user_answers] = test_card_hash[test_card.id][:user_answers]
          test_card&.results[:success] = test_card_hash[test_card.id][:user_answers]&.sort == test_card&.results['result_list']&.sort
          total_success_answer +=1 if test_card&.results[:success]
        end
        test_card&.results[:answered] = true
        test_card.status = 'submitted'
        test_card.save!
      end
      test_session.results = {
        total_question: total_question,
        total_answer: total_answer,
        total_success_answer: total_success_answer
      }
      test_session.status = 'submitted'
      test_session.save!
      return RenderUtil.render_json_obj(
        ['Submit test session successfully!'],
        TestService::Serializer.test_session_with_test_cards(test_session)
      )
    end

  end
end