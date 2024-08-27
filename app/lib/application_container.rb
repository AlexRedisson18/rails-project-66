# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:github_client) { Github::ClientStub }
  else
    register(:github_client) { Github::Client }
  end
end
