class Api::V1::Workplace::CardCollectionController < Api::V1::Workplace::WorkplaceBaseController
  before_action :set_card_collection, only: [:show, :update, :destroy, :cards]

  def index
    return_obj = CardCollectionService::Searcher.card_collection(params, current_user)
    render json: return_obj, status: :ok
  end

  def cards

    return_obj = CardCollectionService::Searcher.cards(params, @card_collection)
    render json: return_obj, status: :ok
  end

  def show
    p @card_collection
    render json: RenderUtil.render_json_obj(
      [CardCollection.found_data_message],
      CardCollectionService::Serializer.card_collection(@card_collection),
    ), status: :ok
  end

  def create
    return_obj = CardCollectionService::Builder.create(card_collection_params, current_user)
    render json: return_obj, status: :ok
  end

  def update
    @card_collection.attributes = card_collection_params
    return (render json: RenderUtil.render_json_obj([CardCollection.update_success_message], _serialize_card_collection(@card_collection)), status: :ok) if @card_collection.save
    render json: { errors: @card_collection.errors.full_messages }, status: :bad_request
  end

  def destroy
    return_obj = CardCollectionService::Builder.destroy(@card_collection)
    render json: return_obj, status: :ok
  end

  private

  def set_card_collection
    begin
      @card_collection = current_user.card_collections.find_by_id(params[:id])
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found if @card_collection.blank?
    rescue
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found
    end
  end

  def card_collection_params
    params[:card_collection].permit(
      :name, :description
    )
  end

  def _serialize_card_collection(data)
    data.as_json()
  end

  def _serialize_card(data)
    data.as_json()
  end

end