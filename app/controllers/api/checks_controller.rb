# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      repository = Repository.find_by(github_id: params['repository']['id'])

      unless repository
        head :not_found
        return
      end

      check = repository.checks.create

      RepositoryCheckJob.perform_later(check.id)

      head :ok
    end
  end
end
