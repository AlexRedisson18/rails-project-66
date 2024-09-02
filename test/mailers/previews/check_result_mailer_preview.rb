# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/check_result_mailer
class CheckResultMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.last
    repository = user.repositories.last
    check = repository.checks.last

    CheckResultMailer.with(user:, repository:, check:).result_email
  end
end
