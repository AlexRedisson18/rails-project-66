# frozen_string_literal: true

module ApplicationHelper
  def github_file_link(check, filename)
    repository = check.repository

    link_to(filename, "https://github.com/#{repository.full_name}/blob/#{check.commit_id}/#{filename}")
  end
end
