# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.log_tags = [:request_id]
end

# TODO: fix deprecation
# Rails.logger.formatter = CustomLogFormatter.new
