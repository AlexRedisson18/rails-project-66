# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :github_id, uniqueness: true, presence: true

  enumerize :language, in: ['ruby']
end
