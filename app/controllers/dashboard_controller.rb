# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @tweets = Tweet.where(restore_at: 24.hours.ago..)
  end
end
