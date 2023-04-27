class Api::V1::Public::HomePolicy < ApplicationPolicy

  def initialize(user, record)
    super(user, record)
  end

  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
