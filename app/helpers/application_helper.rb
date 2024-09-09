# frozen_string_literal: true

module ApplicationHelper
  def github_file_link(check, filename)
    repository = check.repository

    link_to(filename, "https://github.com/#{repository.full_name}/blob/#{check.commit_id}/#{filename}")
  end

  def github_commit_link(check)
    return '' unless check.commit_id

    short_commt = check.commit_id[0..5]
    repository = check.repository

    link_to(short_commt, "https://github.com/#{repository.full_name}/commit/#{short_commt}")
  end
end
