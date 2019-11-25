require 'parslet'

class BescomTweetParser < Parslet::Parser
  root(:bescom)
  rule(:restore_prefix) { str('restored @') }
  rule(:affected_areas_prefix) { str('Affected areas') }
  rule(:affected_areas_postfix) { str('and') }

  rule(:restore) do
    (restore_prefix.absent? >> any).repeat >>
      restore_prefix >>
      space.maybe >>
      (hrs >> colon >> hrs).as(:restore_at)
  end

  rule(:affected_areas) do
    (affected_areas_prefix.absent? >> any).repeat >>
      colon.maybe >>
      space.maybe >>
      quote.maybe >>
      affected_areas_prefix >>
      (newline.absent? >> any).repeat.as(:affected_area)
  end

  rule(:bescom) do
    restore >> affected_areas >> any.repeat
  end

  rule(:hrs) { match('[0-9]').repeat }
  rule(:colon) { str(':') }
  rule(:space) { str(' ') }
  rule(:dot) { str('.') }
  rule(:quote) { str('"') }
  rule(:newline) { match["\n"].repeat(1) }
end
