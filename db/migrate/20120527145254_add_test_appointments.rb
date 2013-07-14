class AddTestAppointments < ActiveRecord::Migration
  def up 
    a = Appointment.new
    a.clinic_doctor_id = ClinicDoctor.find(1).id
    a.patient_id = Patient.first.id
    a.date = Date.new(2014, 1, 1)
    t = DateTime.new(0)
    a.start = t + 8.hours
    a.stop = t + 30.minutes
    a.save!
  end

  def down
    for a in 1..1 do
      appointment = Appointment.find(a)
      appointment.destroy
    end
  end
end
