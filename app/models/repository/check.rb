# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :check_running, :checked, :failed

    event :run_check do
      transitions from: %i[created checked failed], to: :check_running
    end

    event :mark_as_checked do
      transitions from: :check_running, to: :checked
    end

    event :mark_as_failed do
      transitions to: :failed
    end
  end
end
