class BatchScanService
  def self.run
    ScanImages.new.run
    FetchLatLangJob.perform_later
  end
end
