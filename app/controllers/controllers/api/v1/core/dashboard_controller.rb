class Api::V1::Core::DashboardController < Api::V1::Core::CoreBaseController

  def index
    render json: { messages: ['hello world'] },
           status: :ok
  end
end
