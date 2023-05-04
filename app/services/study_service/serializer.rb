module StudyService
  module Serializer
    def self.study_session_with_card_collection(data)
      data.as_json(
        include: [
          card_collection: { except: [:created_at, :updated_at] },
        ]
      )
    end

  end
end
