# frozen_string_literal: true

require 'parslet'

class BescomTweetParser < Parslet::Parser
  root(:bescom)
  rule(:restore_prefix) { str('@') }
  rule(:affected_areas_prefix) do
    (str('areas') | str('Areas') | str('Arcas')) >> newline.maybe >>
      colon.maybe >>
      newline.maybe
  end

  rule(:restore) do
    (restore_prefix.absent? >> any).repeat >>
      restore_prefix >>
      space.maybe >>
      (hrs >> colon.maybe >> dot.maybe >> hrs).as(:restore_at)
  end

  rule(:affected_areas) do
    (affected_areas_prefix.absent? >> any).repeat >>
      affected_areas_prefix >>
      space.maybe >>
      quote.maybe >>
      (dot.maybe >> newline.absent? >> any).repeat.as(:affected_area)
  end

  rule(:bescom) do
    restore >> affected_areas.maybe >> any.repeat
  end

  rule(:hrs) { match('[0-9]').repeat }
  rule(:colon) { str(':') }
  rule(:space) { str(' ') }
  rule(:dot) { str('.') }
  rule(:quote) { str('"') }
  rule(:newline) { match["\n"].repeat(1) }
end
