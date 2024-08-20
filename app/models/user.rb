# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 2, maximum: 50 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
