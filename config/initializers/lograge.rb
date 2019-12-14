# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.log_tags = %i[request_id remote_ip]
end

Rails.logger.formatter = CustomLogFormatter.new
