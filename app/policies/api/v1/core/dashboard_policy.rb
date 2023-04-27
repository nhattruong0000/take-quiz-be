class Api::V1::Core::DashboardPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def index?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def customer_exp_search?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def customer_churn_search?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def sale_order_stats?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
