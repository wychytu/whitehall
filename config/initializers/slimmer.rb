Rails.application.config.slimmer.logger = Rails.logger
Rails.application.config.slimmer.enable_debugging = true
if Rails.env.development?
  # XXX: This needs to specifically be inserted here, as the NewRelic
  # middleware comes after Slimmer, but we need to run before that,
  # but after Slimmer. Otherwise Slimmer won't pick up our header.
  Rails.application.config.middleware.insert_after Slimmer::App, Whitehall::NewRelicDeveloperMode
end
