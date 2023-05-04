class Api::V1::Workplace::TestSessionController < Api::V1::Workplace::WorkplaceBaseController
  before_action :set_card_collection, only: [:create]
  before_action :set_test_card, only: [:answer_test_card]
  before_action :set_test_session, only: [:submit_test]

  def index
    return_obj = TestService::Searcher.test_sessions(params, current_user)
    render json: return_obj, status: :ok
  end
  def create
    return_obj = TestService::Builder.generate_test_session(test_session_params, @card_collection, current_user)
    render json: return_obj, status: :ok
  end

  def answer_test_card
    return_obj = TestService::Builder.update_test_card_by_user_response(test_card_params, @test_card, current_user)
    render json: return_obj, status: :ok
  end

  def submit_test
    return_obj = TestService::Builder.submit_test_cards(submit_test_params, @test_session, current_user)
    render json: return_obj, status: :ok
  end

  private

  def set_card_collection
    begin
      @card_collection = current_user.card_collections.find_by_id(test_session_params[:card_collection_id])
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found if @card_collection.blank?
    rescue
      return render json: RenderUtil.render_json_obj([CardCollection.not_found_message]), status: :not_found
    end
  end

  def set_test_card
    begin
      @test_card = TestCard.find_by_id(params[:test_card_id])
      return render json: RenderUtil.render_json_obj([TestCard.not_found_message]), status: :not_found if @test_card.blank?
    rescue
      return render json: RenderUtil.render_json_obj([TestCard.not_found_message]), status: :not_found
    end
  end

  def set_test_session
    begin
      @test_session = TestSession.find_by_id(params[:id])
      return render json: RenderUtil.render_json_obj([TestSession.not_found_message]), status: :not_found if @test_session.blank?
    rescue
      return render json: RenderUtil.render_json_obj([TestSession.not_found_message]), status: :not_found
    end
  end

  def test_session_params
    params[:test_session].permit(
      :card_collection_id,
      configs: {}
    )
  end

  def test_card_params
    params[:test_card].permit(
      user_answers: []
    )
  end

  def submit_test_params
    params[:test_result].permit(
      test_cards: [
        :test_card_id,
        user_answers: []
      ]
    )
  end

end