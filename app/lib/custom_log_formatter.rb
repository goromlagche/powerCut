# frozen_string_literal: true

class CustomLogFormatter < ActiveSupport::Logger::SimpleFormatter
  include ActiveSupport::TaggedLogging::Formatter

  def call(severity, timestamp, _progname, msg)
    {
      '@timestamp' => timestamp.utc.iso8601(3),
      '@version' => 1,
      level: severity,
      guid: current_tags.join(' ') || SecureRandom.uuid,
      pid: $PID
    }.merge(msg_to_h(msg)).to_json.to_s + " \n"
  end

  def msg_to_h(msg)
    case msg
    when String
      { message: msg.to_s }
    when Exception
      {
        error: msg.class,
        error_message: "#{msg.message}\n" + (msg.backtrace || []).join("\n")
      }
    else
      { message: msg.inspect }
    end
  end
end
