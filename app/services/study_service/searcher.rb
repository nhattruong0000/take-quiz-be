include Pagy::Backend

module StudyService
  module Searcher
    def self.study_sessions(params, current_user)

      relation_card_collection_ids = current_user.card_collections.pluck(:id)
      @query = StudySession.where(card_collection_id: relation_card_collection_ids).ransack(params[:query])
      current_page = params[:page] || 1
      @query.sorts = ['created_at desc'] if @query.sorts.empty?
      data_obj = {}
      pagy, study_session_list = pagy @query.result, items: params[:items], page: current_page
      data_obj[:study_sessions] = StudyService::Serializer.study_session_with_card_collection study_session_list
      data_obj[:current_page] = pagy.page
      data_obj[:total_page] = pagy.pages
      data_obj[:total_records] = pagy.count
      RenderUtil.render_json_obj(
        [StudySession.found_data_message],
        data_obj
      )
    end
  end

end