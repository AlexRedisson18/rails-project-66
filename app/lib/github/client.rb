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
        content_type: 'json',
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


# {:type=>"Repository",
#  :id=>498735139,
#  :name=>"web",
#  :active=>true,
#  :events=>["push"],
#  :config=>
#   {:content_type=>"json",
#    :insecure_ssl=>"0",
#    :url=>"https://e456-94-137-18-209.ngrok-free.app/api/checks"},
#  :updated_at=>2024-08-29 10:54:33 UTC,
#  :created_at=>2024-08-29 10:54:33 UTC,
#  :url=>
#   "https://api.github.com/repos/AlexRedisson18/rails-project-66/hooks/498735139",
#  :test_url=>
#   "https://api.github.com/repos/AlexRedisson18/rails-project-66/hooks/498735139/test",
#  :ping_url=>
#   "https://api.github.com/repos/AlexRedisson18/rails-project-66/hooks/498735139/pings",
#  :deliveries_url=>
#   "https://api.github.com/repos/AlexRedisson18/rails-project-66/hooks/498735139/deliveries",
#  :last_response=>{:code=>200, :status=>"active", :message=>"OK"}}
