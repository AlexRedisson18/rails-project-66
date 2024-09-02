# frozen_string_literal: true

class RepositoryCheckService
  def initialize(check)
    @check = check
    @repository = @check.repository
    @github_client = ApplicationContainer[:github_client].new(@repository)
    @tmp_dir_path = Rails.root.join('tmp', 'repositories', @repository.id.to_s)
    @bash_runner = ApplicationContainer[:bash_runner]
  end

  def call
    return unless linter

    @check.run_check!

    clone_repository
    update_commit_id

    call_linter
    remove_directory

    @check.mark_as_finished!
  rescue StandardError
    @check.mark_as_failed!
  ensure
    CheckResultMailer.with(user: @repository.user, repository: @repository, check: @check).result_email.deliver_later
  end

  private

  def clone_repository
    prepare_directory
    bash_command = "git clone #{@repository.clone_url} #{@tmp_dir_path}"

    @bash_runner.run(bash_command)
  end

  def prepare_directory
    FileUtils.mkdir_p(@tmp_dir_path)
    FileUtils.rm_rf(@tmp_dir_path) if Dir.exist?(@tmp_dir_path) && !Dir.empty?(@tmp_dir_path)
  end

  def update_commit_id
    @check.update(commit_id: @github_client.last_commit_sha)
  end

  def call_linter
    linter.new(@check, @tmp_dir_path).call
  end

  def remove_directory
    FileUtils.rm_rf(@tmp_dir_path)
  end

  def linter
    case @repository.language
    when 'ruby'
      Linter::RubyService
    when 'javascript'
      Linter::JavascriptService
    end
  end
end
