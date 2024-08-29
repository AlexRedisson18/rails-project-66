# frozen_string_literal: true

class Linter::JavascriptService
  def initialize(check, tmp_dir_path)
    @check = check
    @tmp_dir_path = tmp_dir_path
  end

  def call
    update_linter_check_result(run_linter)
  end

  private

  def bash_command
    "yarn run eslint #{@tmp_dir_path} -f json -c eslint.config.mjs"
  end

  def run_linter
    bash_output = BashRunner.run(bash_command).split("\n")[2..-2].join("\n")

    JSON.parse(bash_output)
  end

  def update_linter_check_result(parsed_result)
    linter_check_result = create_files_hash(parsed_result)
    passed = linter_check_result[:offenses_count].zero?

    @check.update(linter_check_result:, passed:)
  end

  def create_files_hash(parsed_result)
    result = { offenses_count: 0, files: {} }
    files_with_errors = parsed_result.filter { |file| file['messages'].any? }

    return result if files_with_errors.empty?

    filename_separator = "#{@tmp_dir_path.to_s.split('/')[-3..].join('/')}/"
    files_with_errors.each do |file|
      filename = file['filePath'].split(filename_separator).last
      result[:files][filename] = []

      file['messages'].each do |message|
        error_data = {
          message: message['message'],
          cop_name: message['ruleId'] || '-',
          start_line: message['line'],
          start_column: message['column']
        }

        result[:files][filename] << error_data
        result[:offenses_count] += 1
      end
    end
    result
  end
end
