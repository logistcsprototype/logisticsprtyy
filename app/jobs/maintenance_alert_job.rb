class MaintenanceAlertJob < ApplicationJob
  queue_as :default

  def perform
    # Find vehicles due for maintenance (e.g., based on mileage or date)
    vehicles_due = Vehicle.where('next_maintenance_date <= ?', Date.today + 7.days)

    vehicles_due.each do |vehicle|
      # Send alert to admin or log it
      AdminMailer.maintenance_alert(vehicle).deliver_later
      # Or create a notification record
      Notification.create(
        admin: vehicle.admin,
        message: "Vehicle #{vehicle.plate_number} is due for maintenance on #{vehicle.next_maintenance_date}"
      )
    end
  end
end