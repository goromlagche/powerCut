# frozen_string_literal: true

class GeoJsonController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: { geo_data: Location
          .where('restore_at > ?', Time.zone.now)
          .pluck(:geo_json) },
               status: :ok
      end
    end
  end
end
