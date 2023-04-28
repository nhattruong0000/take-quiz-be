class Api::V1::Workplace::StudySessionPolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def create?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end

  def answer_study_card?
    STUDENT_DEFAULT_ROLES.include?(user.role)
  end



  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
