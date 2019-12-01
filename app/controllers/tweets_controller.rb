# frozen_string_literal: true

class TweetsController < ApplicationController
  def index
    @tweets = Tweet.where(restore_at: 24.hours.ago..)
    if params[:q].present?
      @tweets = @tweets.text_search(params[:q]).with_pg_search_highlight
    end

    @tweets = @tweets.order(restore_at: :desc).page(params[:page]).without_count
  end
end
