# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:github_client) { Github::ClientStub }
    register(:bash_runner) { BashRunnerStub }
  else
    register(:github_client) { Github::Client }
    register(:bash_runner) { BashRunner }
  end
end
