# frozen_string_literal: true

class Github::ClientStub
  attr_reader :repository, :user, :client

  def initialize(repository, user = nil)
    @repository = repository
    @user = user || @repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def all_repos
    [{
      github_id: @repository.github_id,
      name: 'repository_name',
      full_name: 'user/repository_name',
      language: 'ruby',
      clone_url: 'https://github.com/user/repository.git',
      ssh_url: 'git@github.com:user/repository.git'
    }]
  end

  def filtered_by_languages_repos
    all_repos.filter { |repo| Repository.language.values.include?(repo[:language]&.downcase) }
  end

  def github_repository
    all_repos.first
  end

  def update_repository!
    @repository.update(repository_attributes)
  end

  def repository_attributes
    {
      name: github_repository[:name],
      full_name: github_repository[:full_name],
      language: github_repository[:language].downcase,
      clone_url: github_repository[:clone_url],
      ssh_url: github_repository[:ssh_url]
    }
  end

  def last_commit_sha
    'df06daf0263c5c29712de1b526b490a1919565e4'
  end
end
