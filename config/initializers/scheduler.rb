# frozen_string_literal: true

if Rails.env.production?
  require 'rufus-scheduler'

  Rufus::Scheduler.singleton.every '10m' do
    Rails.logger.info('Running scheduler')
    ScanImages.new.run
    FetchLatLangJob.perform_later
  end
end
