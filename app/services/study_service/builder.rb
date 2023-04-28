module StudyService
  module Builder
    def self.generate_study_session(study_params, card_collection, current_user)
      #create study_session
      study_session = StudySession.create(
        configs: study_params[:configs],
        card_collection_id: card_collection.id,
      )
      study_cards = []
      number_of_question = study_params[:configs][:question_count]
      cards = card_collection.cards.sample(number_of_question)
      questions = QuestionService::Builder.question_generator(cards)
      cards.each do |card|
        study_cards << StudyCard.new(
          card_id: card.id,
          study_session_id: study_session.id,
          question_type: question_type,
          questions: questions[:questions],
          answers: questions[:answers],
          results: questions[:results]
        )
      end
    end


  end
end