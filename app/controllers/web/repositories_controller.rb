# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = current_user.repositories.build
      authorize @repository

      @repositories = filtered_by_language_repos.map { |repo| [repo[:full_name], repo[:id]] }
    end

    def create
      authorize Repository

      @repository = current_user.repositories.find_or_initialize_by(repository_params)

      if @repository.save
        RepositoryLoaderJob.perform_later(@repository.id, current_user.token)

        flash[:notice] = t('flash.repositories.create.success')
        redirect_to repositories_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def client_repos
      client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
      client.repos
    end

    def filtered_by_language_repos
      client_repos.filter { |repo| Repository.language.values.include?(repo[:language]&.downcase) }
    end
  end
end
