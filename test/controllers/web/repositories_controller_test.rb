# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @github_id = 123_456
    @repository = repositories(:one)

    sign_in(@user)
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end

  test 'should get new' do
    get new_repository_path
    assert_response :success
  end

  test 'should create repository' do
    post repositories_path, params: { repository: { github_id: @github_id } }

    assert Repository.find_by(github_id: @github_id)
  end

  test 'should show repository' do
    get repository_path(@repository)
    assert_response :success
  end
end
