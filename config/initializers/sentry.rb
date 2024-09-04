# frozen_string_literal: true

Sentry.init do |config|
  config.enabled_environments = %w[production]

  config.dsn = 'https://0299b726016dd0f316cf4f5434230d6e@o4507893603565568.ingest.de.sentry.io/4507893607432273'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for tracing.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end
