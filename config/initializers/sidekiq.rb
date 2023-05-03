# Sidekiq::Extensions.enable_delay!

if Rails.env.development?
  ENV["REDIS_URL"] = "redis://localhost:6379"
  ENV["REDIS_SIDEKIQ_DB"] = "1"
  ENV["SIDEKIQ_AUTH_USERNAME"] = "admin"
  ENV["SIDEKIQ_AUTH_PASSWORD"] = "123123A@"
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "#{ENV['REDIS_URL']}/#{ENV['REDIS_SIDEKIQ_DB']}",
    namespace: "take-quiz-backend"
  }

  schedule_file = "config/schedule.yml"
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "#{ENV['REDIS_URL']}/#{ENV['REDIS_SIDEKIQ_DB']}" ,
    namespace: "take-quiz-backend"
  }
end