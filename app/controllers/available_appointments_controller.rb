class AvailableAppointmentsController < ApplicationController
  load_and_authorize_resource :work_plan
  # GET /available_appointments
  # GET /available_appointments.json
  def index
    appointments = []
    (0..7*1-1).each do |day|
      date = Date.today + day.days
      appointments |= appointments_for_date(date)
    end
    #appointments = appointments_for_date(Date.today)
    
    @available_appointments = appointments
    #render :text => appointments.to_json
    #return
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @available_appointments }
    end
    #expires_in 30.minutes, public: true
  end
  
  def appointments_for_date(date)
    appointments = []
    WorkPlan.where(:day => date.wday).each do |wp|
      wday = wp.day
      start = wp.start
      stop_ = wp.stop
      clinic_doctor_id = wp.clinic_doctor_id
      if Date.today.wday == wday
        now = DateTime.now
        now.min > 30 ? now = now.change(:hour => now.hour + 1) : now = now.change(:min => 30)
        start = DateTime.new(0)
        start += now.hour.hours + now.min.minutes
      end
      while start <= stop_ - 30.minutes
        unless Appointment.where('confirmed_at IS NOT NULL').where(:clinic_doctor_id => clinic_doctor_id, :date => date, :start => start).exists?
          available = true
        else
          available = false
        end
        appointments << [Appointment.new(:date => date, :start => start, :stop => start + 30.minutes, :clinic_doctor_id => clinic_doctor_id), available]
        start += 30.minutes
      end
    end
    return appointments
  end
end
