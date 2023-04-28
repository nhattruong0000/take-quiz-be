module QuestionService
  module Builder
    def self.question_generator(cards)
      return_obj = {}
      list_answer = cards.pluck(:answer)
      list_question = cards.pluck(:question)
      cards.each do |card|
        question_type = rand(0..1) #random question
        question_obj = {}
        answer_obj = {}
        result_obj = {}
        if(question_type == 0)
          is_card_question = [true, false].sample #is card question is question of this item
          question_obj['question'] = is_card_question ? card.question : card.answer
          question_obj['is_card_question'] = is_card_question

          result_obj['result_list'] = [is_card_question ? card.answer : card.question]
          result_obj['is_multiple_result'] = false

          answer_arr = [is_card_question ? card.answer : card.question]
          answer_arr =  answer_arr + (is_card_question ? list_answer.uniq.excluding(card.answer).sample(3) : list_question.uniq.excluding(card.question).sample(3))

          answer_obj['answer_list'] = answer_arr
        else
          is_right_as_the_answer = [true, false].sample #result right as the answer
          question_obj['question'] = "#{card.question} => #{list_answer.sample}"
          question_obj['question'] = "#{card.question} => #{card.answer}" if is_right_as_the_answer

          result_obj['result_list'] = [is_right_as_the_answer]
          result_obj['is_multiple_result'] = false
          result_obj['answered'] = false
          answer_obj['answers'] = [true, false]
        end

        return_obj[card.id] = {
          question_type: question_type,
          questions: question_obj,
          answers: answer_obj,
          results: result_obj
        }

      end
      return_obj
    end
  end
end