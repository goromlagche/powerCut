# frozen_string_literal: true

class AddIndexsOnTweet < ActiveRecord::Migration[6.0]
  def up
    execute 'create index articles_name on tweets '\
            "using gin(to_tsvector('english', raw_data))"
  end

  def down
    execute 'drop index tweets_raw_data'
  end
end
