module QuestionService
  module Util
    def self.default_configs(params)
      if params.has_key?(:configs) == false
        params = params.to_h.merge(
          configs: {
            question_count: 10,
          }
        )
      end
      params
    end

    def self.default_configs_for_test(params)
      if params.has_key?(:configs) == false
        params = params.to_h.merge(
          configs: {
            question_count: 10,
            execution_time: 15
          }
        )
      end
      params
    end
  end
end