# frozen_string_literal: true

# Ugly location parser
class LocationParser
  attr_reader :affected_areas

  def initialize(affected_areas:)
    @affected_areas = affected_areas
  end

  def self.parse(affected_areas:)
    locations = new(affected_areas: affected_areas)
    locations
      .filter_chars # accept only certain chars
      .surrounding # remove surrounding
      .and # replace and with comma
      .dot # replace dot with comma
      .part # maker part, full
      .layout # replace lo with layout
      .electronic_city # replace electronic city with electronics, as nominatim doesnt respond on the former
      .split_locations
  end

  def split_locations
    affected_areas
      .strip
      .split(',')
      .map(&:strip)
      .select { |location| not_near(location) }
  end

  def not_near(location)
    !location.start_with?('near ')
  end

  def part
    affected_areas.gsub!(/part of/i, ',')
    self
  end

  def dot
    affected_areas.gsub!(/\./, ',')
    self
  end

  def filter_chars
    @affected_areas =
      affected_areas.scan(/([a-z]|[A-Z]|[0-9]|,| |\.)/).join.gsub(/\s+/, ' ')
    self
  end

  def layout
    affected_areas.gsub!(/ lo/i, ' Layout')
    affected_areas.gsub!(/ vo/i, ' Layout')
    affected_areas.gsub!(%r{ l/o}i, ' Layout')
    affected_areas.gsub!(%r{ v/o}i, ' Layout')
    self
  end

  def electronic_city
    affected_areas.gsub!(/Electronic /i, 'Electronics ')
    self
  end

  def surrounding
    if affected_areas.scan(/.*surrounding/i).present?
      @affected_areas =
        affected_areas.scan(/.*surrounding/i).join.gsub(/surrounding/i, ' ')
    end
    self
  end

  def and
    affected_areas.gsub!(/ and /i, ',')
    self
  end

  def to_s
    affected_areas
  end
end
