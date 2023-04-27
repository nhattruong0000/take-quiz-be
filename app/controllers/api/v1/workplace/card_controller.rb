class Api::V1::Workplace::CardController < Api::V1::Workplace::WorkplaceBaseController
  before_action :set_card_collection, only: [:create, :update, :destroy]

  def create
    return_obj = CardService::Builder.create(card_params[:cards], @card_collection, current_user)
    render json: return_obj, status: :ok
  end

  def update
    return_obj = CardService::Builder.update(card_params[:cards], @card_collection, current_user)
    render json: return_obj, status: :ok
  end

  def destroy
    return_obj = CardService::Builder.destroy(card_params[:cards], @card_collection, current_user)
    render json: return_obj, status: :ok
  end

  private

  def set_card_collection
    begin
      @card_collection = current_user.card_collections.find_by_id(params[:obj][:card_collection_id])
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found if @card_collection.blank?
    rescue
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found
    end
  end

  def card_params
    params[:obj].permit(:card_collection_id, cards: [:id, :question, :answer])
  end

end