# frozen_string_literal: true

class Github::Client
  attr_reader :repository, :user, :client

  def initialize(repository, user = nil)
    @repository = repository
    @user = user || @repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def filtered_by_languages_repos
    languages = Repository.language.values

    @client.repos.filter { |repo| languages.include?(repo[:language]&.downcase) }
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

  def current_repository_webhook
    @client.hooks(@repository.github_id).find { |hook| hook[:config][:url] == webhook_api_checks_url }
  end

  def create_repository_webhook
    return if current_repository_webhook

    @client.create_hook(
      @repository.full_name,
      'web',
      {
        url: webhook_api_checks_url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end

  private

  def webhook_api_checks_url
    Rails.application.routes.url_helpers.api_checks_url
  end
end
