include Pagy::Backend

module CardCollectionService
  module Searcher
    def self.card_collection(params, current_user)
      @query = current_user.card_collections.ransack(params[:query])
      current_page = params[:page] || 1
      @query.sorts = ['name asc'] if @query.sorts.empty?
      data_obj = {}
      pagy, card_collection_list = pagy @query.result, items: params[:items], page: current_page
      data_obj[:card_collections] = CardCollectionService::Serializer.card_collection card_collection_list
      data_obj[:current_page] = pagy.page
      data_obj[:total_page] = pagy.pages
      data_obj[:total_records] = pagy.count
      RenderUtil.render_json_obj(
        [CardCollection.found_data_message],
        data_obj
      )

    end

    def self.cards(params, card_collection)
      @query = card_collection.cards.ransack(params[:query])
      current_page = params[:page] || 1
      @query.sorts = ['name asc'] if @query.sorts.empty?
      data_obj = {}
      pagy, card_list = pagy @query.result, items: params[:items], page: current_page
      data_obj[:cards] = CardCollectionService::Serializer.card card_list
      data_obj[:current_page] = pagy.page
      data_obj[:total_page] = pagy.pages
      data_obj[:total_records] = pagy.count
      RenderUtil.render_json_obj(
        [Card.found_data_message],
        data_obj
      )
    end
  end

end