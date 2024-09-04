# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      user_data = request.env['omniauth.auth']
      user = find_or_initialize_user(user_data)

      if user.save
        sign_in(user)
        flash[:notice] = t('flash.auth.sign_in.success')
      else
        flash[:alert] = t('flash.auth.sign_in.error')
      end

      redirect_to root_path
    end

    def logout
      sign_out
      redirect_to root_path, notice: t('flash.auth.sign_out.success')
    end

    private

    def find_or_initialize_user(user_data)
      email = user_data.dig(:info, :email).downcase
      user = User.find_or_initialize_by(email:)
      assign_user_attributes(user, user_data)
    end

    def assign_user_attributes(user, user_data)
      nickname = user_data.dig(:info, :nickname)
      token = user_data.dig(:credentials, :token)
      provider = user_data[:provider]
      uid = user_data[:uid]

      attributes = { nickname:, token:, provider:, uid: }

      user.assign_attributes(attributes)
      user
    end
  end
end
