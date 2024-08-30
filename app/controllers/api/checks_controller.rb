# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    protect_from_forgery with: :null_session

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
