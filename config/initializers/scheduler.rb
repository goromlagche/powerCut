require 'rufus-scheduler'

if Rails.env.production?
  Rufus::Scheduler.singleton.every '5m' do
    Rails.logger.info('Running scheduler')
    ScanImages.new.run
    FetchLatLangJob.perform_later
  end
end
