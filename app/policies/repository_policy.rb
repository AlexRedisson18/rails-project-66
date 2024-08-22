# frozen_string_literal: true

class RepositoryPolicy
  attr_reader :user, :repository

  def initialize(user, repository)
    @user = user
    @repository = repository
  end

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
    repository.user == user
  end
end
