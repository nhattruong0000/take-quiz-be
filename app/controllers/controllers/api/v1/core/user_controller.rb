class Api::V1::Core::UserController < Api::V1::Core::CoreBaseController
  before_action :set_user, only: [:show, :destroy, :update, :lock, :unlock, :reset_password]

  def index
    @query = User.includes(:user_configs).ransack(params[:query])
    current_page = params[:page] || 1
    # @query.sorts = ['name asc'] if @query.sorts.empty?
    return_obj = {}

    pagy, user_list = pagy @query.result, items: params[:items], page: current_page
    return_obj[:users] = _serialize_user_info user_list
    return_obj[:current_page] = pagy.page
    return_obj[:total_page] = pagy.pages
    return_obj[:total_records] = pagy.count
    render json: { messages: [User.found_data_message],
                   data: return_obj },
           status: :ok
  end

  def show
    render json: _serialize_user_info(@user), status: :ok
  end

  def update
    @user.attributes = user_params
    @user.initial_password = user_params[:password] if user_params[:password]
    return (render json: _serialize_user_info(@user), status: :ok) if @user.save
    render json: { errors: @user.errors.full_messages }, status: :bad_request
  end

  def lock
    @user.locked_at = DateTime.now
    return (render json: { messages: [User.lock_success_message] }, status: :ok) if @user.save
    render json: { errors: @user.errors.full_messages }, status: :bad_request
  end

  def unlock
    @user.locked_at = nil
    return (render json: { messages: [User.unlock_success_message] }, status: :ok) if @user.save
    render json: { errors: @user.errors.full_messages }, status: :bad_request
  end

  def destroy
    #TODO: check destroy condition on user
    return render json: { messages: [User.destroy_success_message] }, status: :ok if @user.destroy
    render json: { errors: @user.errors.full_messages }, status: :bad_request
  end

  def reset_password
    gen_pass = SecureRandom.hex[0, 8]
    @user.password = gen_pass
    @user.initial_password = gen_pass
    if @user.save
      @user.send_zns_account_info
      return (render json: { messages: [User.reset_success_message] }, status: :ok)
    end
    render json: { errors: @user.errors.full_messages }, status: :bad_request
  end

  private

  def set_user
    begin
      @user = User.find_by_id(params[:id])
      return render json: { errors: [User.not_found_message] }, status: :not_found if @user.blank?
    rescue => exception
      return render json: { errors: [User.not_found_message] }, status: :not_found
    end
  end

  def _serialize_user_info data
    data.as_json(
      only: %i[id email full_name username role failed_attempts must_change_password initial_password locked_at last_sign_in_at created_at updated_at],
      include: [
        user_configs: { except: [:created_at, :updated_at] }
      ]
    )
  end

  def user_params
    params[:user].permit(:email,
                         :username,
                         :password,
                         :role)
  end

end