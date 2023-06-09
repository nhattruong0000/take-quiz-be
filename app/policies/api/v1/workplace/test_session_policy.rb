class Api::V1::Workplace::TestSessionPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def index?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def create?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def answer_test_card?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def submit_test?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end



  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
