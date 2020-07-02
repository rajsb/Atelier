# frozen_string_literal: true

require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should show user' do
    get api_v1_user_url(@user), as: :json
    assert_response :success

    # Check if response contains the correct email
    json_response = JSON.parse(response.body)
    assert_equal(@user.email, json_response['email'])
  end

  test 'should create user' do
    # check if post request with valid data results in user count change
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'test@test.org', password: '123456' } }, as: :json
    end

    # checking if response status code is 201
    assert_response :created
  end

  test 'should not create user with taken email' do
    # existing user email should result in no count change of user model
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: '123456' } }, as: :json
    end

    # checking if response status code is 422
    assert_response :unprocessable_entity
  end

  test 'should update user' do
    patch api_v1_user_url(@user), params: { user: { email: @user.email, password: '123456' } }, headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }, as: :json
    assert_response :success
  end

  test 'should forbid update user' do
    patch api_v1_user_url(@user), params: { user: { email: @user.email } }, as: :json
    assert_response :forbidden
  end

  # test 'should not update user when invalid params are sent' do
  #   patch api_v1_user_url(@user), params: { user: { email: 'bad_email', password: '123456' } }, as: :json
  #   assert_response :unprocessable_entity
  # end

  # we respond with content of 204 which is No content
  test 'should destroy the user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }, as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy user' do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :forbidden
  end
end
