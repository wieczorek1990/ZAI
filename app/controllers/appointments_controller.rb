class AppointmentsController < ApplicationController
  load_and_authorize_resource
  caches_page :index, :show

  # GET /appointments
  # GET /appointments.json
  def index
    if current_user.is_a?(Admin)
      @appointments = Appointment.all
    elsif current_user.is_a?(Doctor)
      @appointments = Appointment.joins(:clinic_doctor).where(:clinic_doctors => {:doctor_id => current_user.id}).where('confirmed_at IS NOT NULL')
    elsif current_user.is_a?(Patient)
      @appointments = Appointment.where(:patient_id => current_user.id)
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.json
  def new
    @appointment = Appointment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
  end

  # POST /appointments
  # POST /appointments.json
  def create 
    #return render :text => params
    params[:appointment][:patient_id] = current_user.id
    @appointment = Appointment.new(params[:appointment])
    
    expire_page appointments_path
    
    create_respond_to(@appointment)
  end

  def create_respond_to(appointment)
    respond_to do |format|
      if appointment.save
        format.html { redirect_to appointment, notice: 'Appointment was successfully created. Please confirm your appointment within 10 minutes!' }
        format.json { render json: appointment, status: :created, location: appointment }
      else
        format.html { render action: "new" }
        format.json { render json: appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])
    expire_page appointments_path
    expire_page appointment_path(@appointment)

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    expire_page appointments_path
    expire_page appointment_path(@appointment)
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end
    
  def confirm 
    @appointment = Appointment.find(params[:id])
    @appointment.confirm!
   
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully confirmed.' }
        format.json { head :no_content }
      else
        format.html { 
          flash[:error] = "Could not save appointment."
          redirect_to :controller => :appointments, :action => :index
        }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #today = Date.today
  #date = today.beginning_of_week(:sunday)
  
  def first_clinic
    @clinic = Clinic.new
    
    respond_to do |format|
      format.html # first_clinic.html.erb
      format.json { render json: @clinic }
    end
  end

  def first_clinic_create
    clinic_id = params[:clinic][:id]
    patient_id = current_user.id
    date = parse_date(params[:date])
    work_plans = WorkPlan.joins(:clinic_doctor).where(:clinic_doctors => {:clinic_id => clinic_id}, :day => date.wday)
    appointments = appointments_from_work_plans(work_plans, date, patient_id)
    @appointment = appointments[0]
    unless @appointment.nil?
      create_respond_to(@appointment)
    else
      flash[:error] = "There are no free appointment hours on selected day"
      redirect_to first_clinic_appointments_path
    end
  end
  
  def first_doctor
    @doctor = Doctor.new
    
    respond_to do |format|
      format.html # first_doctor.html.erb
      format.json { render json: @doctor }
    end
  end
  
  def first_doctor_create
    doctor_id = params[:doctor][:id]
    patient_id = current_user.id
    date = parse_date(params[:date])
    work_plans = WorkPlan.joins(:clinic_doctor).where(:clinic_doctors => {:doctor_id => doctor_id}, :day => date.wday)
    appointments = appointments_from_work_plans(work_plans, date, patient_id)
    @appointment = appointments[0]
    unless @appointment.nil?
      create_respond_to(@appointment)
    else
      flash[:error] = "There are no free appointment hours on selected day"
      redirect_to first_doctor_appointments_path
    end
  end
  
  def parse_date(date_json)
    Date.new(date_json['date(1i)'].to_i, date_json['date(2i)'].to_i, date_json['date(3i)'].to_i)
  end
  
  def appointments_from_work_plans(work_plans, date, patient_id)
    appointments = []
    work_plans.each do |wp|
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
          appointments << Appointment.new(:date => date, :start => start, :stop => start + 30.minutes, :clinic_doctor_id => clinic_doctor_id, :patient_id => patient_id)
        end
        start += 30.minutes
      end
    end
    return appointments
  end
end
