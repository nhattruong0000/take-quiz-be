module CardService
  module Serializer
    def self.card(data)
      data.as_json()
    end

  end
end
