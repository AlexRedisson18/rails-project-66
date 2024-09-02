# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:one)

    sign_in(@user)
  end

  test '#create' do
    assert_difference('Repository::Check.count', 1) do
      params = { repository: { id: @repository.github_id } }
      post(api_checks_url, params:)

      assert_response :success
    end

    perform_enqueued_jobs

    assert { @repository.checks.last.finished? }
    assert { @repository.checks.last.passed }
  end
end
