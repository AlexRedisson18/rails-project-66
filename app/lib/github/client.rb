# frozen_string_literal: true

class Github::Client
  attr_reader :repository, :user, :client

  def initialize(repository, user = nil)
    @repository = repository
    @user = user || @repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def all_repos
    @client.repos
  end

  def filtered_by_languages_repos
    languages = Repository.language.values

    all_repos.filter { |repo| languages.include?(repo[:language]&.downcase) }
  end

  def github_repository
    @client.repo(@repository.github_id)
  end

  def update_repository!
    @repository.update(github_repository_attributes)
  end

  def github_repository_attributes
    {
      name: github_repository[:name],
      full_name: github_repository[:full_name],
      language: github_repository[:language].downcase,
      clone_url: github_repository[:clone_url],
      ssh_url: github_repository[:ssh_url]
    }
  end

  def last_commit_sha
    @client.commits(@repository.github_id).first[:sha]
  end
end
