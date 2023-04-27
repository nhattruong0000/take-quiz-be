class Api::V1::Common::UserProfilePolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def show?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def change_password?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def update_ui_config?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
