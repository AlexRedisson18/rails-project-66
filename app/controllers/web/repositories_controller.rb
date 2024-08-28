# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository

      @checks = @repository.checks.order(created_at: :desc)
    end

    def new
      @repository = current_user.repositories.build
      authorize @repository

      @github_client = ApplicationContainer[:github_client].new(@repository, current_user)

      @repositories = @github_client.filtered_by_languages_repos.map { |repo| [repo[:full_name], repo[:id]] }
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      authorize @repository

      if @repository.save
        RepositoryLoadInfoJob.perform_later(@repository.id)

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
      client_repos.filter { |repo| Repository.language.value?(repo[:language]&.downcase) }
    end
  end
end
