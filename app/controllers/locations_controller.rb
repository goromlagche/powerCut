# frozen_string_literal: true

class LocationsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: { locations:
                         Location
                           .lat_lng
                           .where(restore_at: 24.hours.ago..)
                           .as_json },
               status: :ok
      end
    end
  end
end
