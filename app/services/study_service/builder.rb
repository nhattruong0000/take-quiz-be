module StudyService
  module Builder
    def self.generate_study_session(study_params, card_collection, current_user)
      authorized, msg = CardCollectionService::Validator.check_card_collection_authorized(card_collection, current_user)
      return RenderUtil.render_json_obj(msg) unless authorized

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

    def self.update_study_card_by_user_response(study_card_params, study_session, study_card, current_user)
      #check authorized
      authorized, msg = StudyService::Validator.check_study_card_authorized(study_card, current_user)
      return RenderUtil.render_json_obj(msg) unless authorized

      # update user result
      study_card&.results[:user_answers] = study_card_params[:user_answers]
      study_card&.results[:answered] = true
      study_card&.results[:success] = study_card_params[:user_answers]&.sort == study_card&.results['result_list']&.sort
      study_card.status = 'submitted'
      study_card.save!

      card = study_card&.card
      # update card information
      update_card_info(card, study_card)

      #update study_session result
      study_session = update_study_session(study_session)

      return RenderUtil.render_json_obj(
        [StudyCard.update_success_message],{
          study_session: study_session,
          study_card: study_card
        }
      )
    end

    private

    def self.update_card_info(card, study_card)
      card.study_count += 1
      if study_card&.results[:success]
        card.success_count += 1
      else
        card.failed_count += 1
      end
      card.study_last_time = DateTime.now()
      card.save!
    end

    def self.update_study_session(study_session)
      #reload info and study card
      study_session.reload

      study_cards = study_session&.study_cards
      total_question = study_cards.count
      total_answer = 0
      total_success_answer = 0
      study_cards.each do |study_card|
        next unless study_card.results
        total_answer += 1 if study_card.results.has_key?('answered')
        total_success_answer += 1 if study_card.results.has_key?('success') && study_card.results['success'] == true
      end
      study_session.results = {
        total_question: total_question,
        total_answer: total_answer,
        total_success_answer: total_success_answer
      }
      study_session.save!
      study_session
    end

  end
end