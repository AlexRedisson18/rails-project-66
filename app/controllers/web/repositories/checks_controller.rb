# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @check = Repository::Check.includes(:repository).find(params[:id])
        authorize @check
      end

      def create
        @repository = Repository.find(params[:repository_id])
        @check = @repository.checks.create
        authorize @check

        RepositoryCheckJob.perform_later(@check.id)

        flash[:notice] = t('flash.repositories.checks.create.success')
        redirect_to @repository
      end
    end
  end
end
