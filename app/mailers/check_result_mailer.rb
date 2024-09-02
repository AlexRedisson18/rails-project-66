# frozen_string_literal: true

class CheckResultMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def result_email
    @user = params[:user]
    @repository = params[:repository]
    @check = params[:check]

    mail(to: @user.email, subject: t('.subject', repository_name: @repository.name))
  end
end
