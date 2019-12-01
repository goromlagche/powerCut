# frozen_string_literal: true

class Tweet < ApplicationRecord
  include PgSearch::Model

  has_many :locations
  validates :url, uniqueness: { case_sensitive: true }, presence: true

  pg_search_scope :text_search,
                  against: :raw_data,
                  using: { tsearch: { any_word: true,
                                      dictionary: 'english',
                                      normalization: 2,
                                      prefix: true,
                                      highlight: {
                                        StartSel: '<b class="tag is-warning">',
                                        StopSel: '</b>',
                                        MaxWords: 123,
                                        MinWords: 456,
                                        ShortWord: 4,
                                        HighlightAll: true,
                                        MaxFragments: 3,
                                        FragmentDelimiter: '&hellip;'
                                      } } }

  def raw_data_text
    pg_search_highlight
  rescue PgSearch::PgSearchHighlightNotSelected
    raw_data
  end
end
