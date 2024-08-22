# frozen_string_literal: true

require 'octokit'

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(repository_id, token)
    repository = Repository.find(repository_id)

    client = Octokit::Client.new(access_token: token, auto_paginate: true)
    github_repo = client.repo(repository.github_id)

    repository.update(repository_attributes(github_repo))
  end

  def repository_attributes(github_repo)
    {
      name: github_repo[:name],
      full_name: github_repo[:full_name],
      language: github_repo[:language].downcase,
      clone_url: github_repo[:clone_url],
      ssh_url: github_repo[:ssh_url]
    }
  end
end
