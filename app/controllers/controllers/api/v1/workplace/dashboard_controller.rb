class Api::V1::Workplace::DashboardController < Api::V1::Workplace::WorkplaceBaseController

  def index
    # return collection list
    collections = current_user.card_collections
    # TODO: return achivement list
    render json: RenderUtil.render_json_obj(
      ['The data has been retrieved successfully'],
      _serialize_card_collection(collections)),
           status: :ok
  end

  private

  def _serialize_card_collection data
    data.as_json()
  end

end
