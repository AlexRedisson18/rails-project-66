# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      user_data = request.env['omniauth.auth']
      user = find_or_initialize_user(user_data)

      if user.save
        sign_in(user)
        flash[:notice] = t('auth.flash.success')
      else
        flash[:alert] = t('auth.flash.error')
      end

      redirect_to root_path
    end

    def logout
      sign_out
      redirect_to root_path, notice: t('auth.flash.success')
    end

    private

    def find_or_initialize_user(user_data)
      email = user_data['info']['email'].downcase
      nickname = user_data['info']['nickname']
      token = user_data['credentials']['token']

      user = User.find_or_initialize_by(email:)
      user.nickname = nickname
      user.token = token

      user
    end
  end
end
