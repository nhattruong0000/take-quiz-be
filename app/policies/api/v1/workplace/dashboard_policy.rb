class Api::V1::Workplace::DashboardPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def index?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
