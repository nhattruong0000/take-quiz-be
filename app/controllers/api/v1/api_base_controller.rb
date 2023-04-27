class Api::V1::ApiBaseController < ApplicationController
  # include Pundit
  # before_action :authentication_user!
  include Pundit::Authorization

  before_action :check_permission
  rescue_from Pundit::NotAuthorizedError, with: :_user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :_record_not_found

  private

  def check_permission
    authorize(self.class.name.gsub("Controller", "").split("::").map { |e| e.underscore.to_sym })
  end

  def _user_not_authorized
    render json: { errors: ["Không có quyền truy cập"] }, status: :forbidden
  end

  def _record_not_found
    render json: { errors: ["Không tìm thấy dữ liệu"] }, status: :not_found
  end

  def default_serialize_data data
    data.as_json(
      except: [:created_at, :updated_at]
    )
  end
end
