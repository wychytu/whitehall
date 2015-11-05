require 'sidekiq/logging/json'

Sidekiq.logger.formatter = Sidekiq::Logging::Json::Logger.new
redis_config = YAML.load_file(Rails.root.join("config", "redis.yml")).symbolize_keys

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.error_handlers << lambda do |exception, context|
     Airbrake.notify(exception, parameters: context)
  end

  config.server_middleware do |chain|
    chain.add Sidekiq::Statsd::ServerMiddleware, env: 'govuk.app.whitehall', prefix: 'workers'
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
