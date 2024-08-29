# frozen_string_literal: true

class Linter::RubyService
  def initialize(check, tmp_dir_path)
    @check = check
    @tmp_dir_path = tmp_dir_path
  end

  def call
    update_linter_check_result(run_linter)
  end

  private

  def bash_command
    "bundle exec rubocop #{@tmp_dir_path} --format json -c .rubocop.yml"
  end

  def run_linter
    bash_output = BashRunner.run(bash_command)

    JSON.parse(bash_output)
  end

  def update_linter_check_result(parsed_result)
    linter_check_result = create_files_hash(parsed_result)
    passed = linter_check_result[:offenses_count].zero?

    @check.update(linter_check_result:, passed:)
  end

  def create_files_hash(parsed_result)
    result = { offenses_count: 0, files: {} }
    offenses_count = parsed_result.dig('summary', 'offense_count')

    return result if offenses_count.zero?

    result[:offenses_count] = offenses_count
    files_with_errors = parsed_result['files'].filter { |file| file['offenses'].any? }

    files_with_errors.each do |file|
      filename = file['path'].split('/')[3..].join('/')
      result[:files][filename] = []

      file['offenses'].each do |offense|
        error_data = {
          message: offense['message'],
          cop_name: offense['cop_name'],
          start_line: offense['location']['start_line'],
          start_column: offense['location']['start_column']
        }

        result[:files][filename] << error_data
      end
    end
    result
  end
end
