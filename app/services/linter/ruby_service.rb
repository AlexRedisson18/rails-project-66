# frozen_string_literal: true

class Linter::RubyService
  def initialize(check, tmp_dir_path)
    @check = check
    @tmp_dir_path = tmp_dir_path
  end

  def call
    parsed_result = JSON.parse(run_linter)
    update_linter_offences(parsed_result)
  end

  private

  def run_linter
    bash_command = "bundle exec rubocop #{@tmp_dir_path} --format json -c .rubocop.yml"
    BashRunner.run(bash_command)
  end

  def update_linter_offences(parsed_result)
    offenses_count = parsed_result.dig('summary', 'offense_count')
    files_with_errors = parsed_result['files'].filter { |file| file['offenses'].any? }

    result = { offenses_count:, files: [] }
    result[:files] = create_files_hash(files_with_errors) if offenses_count.positive?

    passed = offenses_count.zero?

    @check.update(linter_check_result: result, passed:)
  end

  def create_files_hash(files_with_errors)
    files_with_errors.each_with_object({}) do |file, acc|
      filename = file['path'].split('/')[3..].join('/')
      acc[filename] = []

      file['offenses'].each do |offense|
        error_data = {
          message: offense['message'],
          cop_name: offense['cop_name'],
          start_line: offense['location']['start_line'],
          start_column: offense['location']['start_column']
        }

        acc[filename] << error_data
      end
    end
  end
end
