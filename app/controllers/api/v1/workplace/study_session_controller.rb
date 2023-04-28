class Api::V1::Workplace::StudySessionController < Api::V1::Workplace::WorkplaceBaseController

  before_action :set_card_collection, only: [:create]

  def create
    return_obj = StudyService::Builder.generate_study_session(study_session_params, @card_collection, current_user)
    render json: return_obj, status: :ok
  end



  private

  def set_card_collection
    begin
      @card_collection = current_user.card_collections.find_by_id(study_session_params[:card_collection_id])
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found if @card_collection.blank?
    rescue
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found
    end
  end

  def study_session_params
    params[:study_session].permit(
      :card_collection_id,
      configs: {}
    )
  end

end