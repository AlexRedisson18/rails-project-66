# frozen_string_literal: true

require 'octokit'

class RepositoryLoadInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)

    github_client = ApplicationContainer[:github_client].new(repository)
    github_client.update_repository!
  end
end
