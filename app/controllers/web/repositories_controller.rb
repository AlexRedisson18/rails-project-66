# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = current_user.repositories.build

      # authorize @bulletin

      client = Octokit::Client.new access_token: current_user.token, auto_paginate: true

      @repositories = client.repos
    end

    def create
      # authorize Bulletin

      @repository = current_user.repositories.build(repository_params)

      if @repository.save
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
  end
end
