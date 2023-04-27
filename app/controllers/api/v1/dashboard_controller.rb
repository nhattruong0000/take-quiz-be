class Api::V1::DashboardController < Api::V1::ApiBaseController

  def index
    
    render json: { messages: ['hello world'] },
           status: :ok
  end

end