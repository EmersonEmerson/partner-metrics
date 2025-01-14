# TODO: Convert to ActiveJob -> Sidekiq
# Split into two workers: ImportCsvJob and ImportPartnerApiJob

class ImportWorker
  @queue = :import_queue

  def self.perform(current_user_id, filename = nil)
    return unless current_user_id

    current_user = User.find(current_user_id)
    last_calculated_metric = current_user.newest_metric_date || 48.months.ago.to_date

    if !filename.nil?
      PaymentHistory.import_csv(current_user, last_calculated_metric_date, filename)
    else
      PaymentHistory.import_partner_api(current_user, last_calculated_metric_date)
    end

    # Payments must be imported fully before metrics can be calculated
    Resque.enqueue(ImportMetricsWorker, current_user_id)
  rescue => e
    current_user.update(import: "Failed", import_status: 100)
    raise e
  end
end
