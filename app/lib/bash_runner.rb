# frozen_string_literal: true

class BashRunner
  def self.run(command)
    stdout, exit_status = Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }

    exit_status.exitstatus
    stdout
  end
end
