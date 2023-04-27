class Api::V1::Public::HomeController < Api::V1::Public::PublicBaseController
  before_action :authentication_user!, except: [:callback]

  def index
    render json: {
      messages: ['Nhận zalo callback thành công']
    }, status: :ok
  end
end