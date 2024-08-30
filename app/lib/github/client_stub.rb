# frozen_string_literal: true

class Github::ClientStub
  attr_reader :repository, :user, :client

  REPOSITORY = {
    name: 'repository_name',
    full_name: 'user/repository_name',
    language: 'ruby',
    clone_url: 'https://github.com/user/repository.git',
    ssh_url: 'git@github.com:user/repository.git'
  }.freeze

  def initialize(repository, user = nil)
    @repository = repository
    @user = user || @repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def filtered_by_languages_repos
    [REPOSITORY].filter { |repo| Repository.language.value?(repo[:language]&.downcase) }
  end

  def github_repository
    REPOSITORY
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
    'df06daf0263c5c29712de1b526b490a1919565e4'
  end

  def current_repository_webhook
    true
  end

  def create_repository_webhook
    true
  end

  private

  def webhook_api_checks_url
    ''
  end
end
