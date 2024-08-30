# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @ruby_repository = repositories(:one)
    @js_repository = repositories(:two)

    @check = repository_checks(:checked)

    sign_in(@user)
  end

  test '#show' do
    get repository_check_url(@ruby_repository.id, @check.id)

    assert_response :success
  end

  test '#create ruby repo' do
    assert_difference('Repository::Check.count', 1) do
      post repository_checks_url(@ruby_repository)
    end

    perform_enqueued_jobs

    check = @ruby_repository.checks.last

    assert { check.checked? }
    assert { check.passed }
  end

  test '#create javascript repo' do
    assert_difference('Repository::Check.count', 1) do
      post repository_checks_url(@js_repository)
    end

    perform_enqueued_jobs

    check = @js_repository.checks.last

    assert { check.checked? }
    assert { check.passed }
  end
end
