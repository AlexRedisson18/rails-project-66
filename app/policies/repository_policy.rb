# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    user
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def show?
    record_owner?
  end
end
