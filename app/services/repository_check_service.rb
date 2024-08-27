# frozen_string_literal: true

class RepositoryCheckService < ApplicationService
  def initialize(check)
    @check = check
    @repository = @check.repository
    @github_client = ApplicationContainer[:github_client].new(@repository)
    @tmp_dir_path = Rails.root.join('tmp', 'repositories', @repository.id.to_s)
  end

  def call
    @check.run_check!

    clone_repository
    update_commit_id
    run_linter
    remove_directory

    @check.mark_as_checked!
  rescue StandardError
    @check.mark_as_failed!
  end

  private

  def clone_repository
    prepare_directory
    command = "git clone #{@repository.clone_url} #{@tmp_dir_path}"

    BashCommand.run(command)
  end

  def update_commit_id
    @check.update(commit_id: @github_client.last_commit_sha)
  end

  def run_linter
    command = "rubocop #{@tmp_dir_path} --format json -c .rubocop.yml"
    parsed_result = JSON.parse(BashCommand.run(command))

    files_with_errors = parsed_result['files'].filter { |file| file['offenses'].any? }

    if files_with_errors.empty?
      @check.update(passed: true)
    else
      assign_errors(files_with_errors)
    end
  end

  def assign_errors(files_with_errors)
    result = {}

    files_with_errors.each do |file|
      filename = file['path'].split('/')[3..].join('/')
      result[filename] = []

      file['offenses'].each do |offense|
        error_data = {
          'message' => offense['message'],
          'cop_name' => offense['cop_name'],
          'start_line' => offense['location']['start_line'],
          'start_column' => offense['location']['start_column']
        }

        result[filename] << error_data
      end
    end

    @check.update(check_data: result)
  end

  def prepare_directory
    FileUtils.mkdir_p(@tmp_dir_path)
    FileUtils.rm_rf(@tmp_dir_path) if Dir.exist?(@tmp_dir_path) && !Dir.empty?(@tmp_dir_path)
  end

  def remove_directory
    FileUtils.rm_rf(@tmp_dir_path)
  end
end
