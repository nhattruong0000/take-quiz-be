class Api::V1::Core::UserPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def index?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def show?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def update?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def lock?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def unlock?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def destroy?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  def reset_password?
    SYS_ADMIN_DEFAULT_ROLES.include?(user.role)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
