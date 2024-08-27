# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    record_repository_owner?
  end

  def create?
    record_repository_owner?
  end
end
