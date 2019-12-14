# frozen_string_literal: true

class CustomLogFormatter < ActiveSupport::Logger::SimpleFormatter
  include ActiveSupport::TaggedLogging::Formatter

  def call(severity, timestamp, _progname, msg)
    {
      '@timestamp' => timestamp.in_time_zone('Asia/Kolkata').iso8601(3),
      level: severity,
      guid: current_tags.first,
      ip: current_tags.second,
      location: location,
      pid: $PID
    }.merge(msg_to_h(msg)).to_json.to_s + " \n"
  end

  private

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

  def location
    add = Geocoder.search(current_tags.second).first
    if add.present?
      [add.city, add.region, add.country].compact.join(', ')
    else
      nil
    end
  end
end
