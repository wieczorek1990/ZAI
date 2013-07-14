class WorkPlan < ActiveRecord::Base
  resourcify
  
  belongs_to :clinic_doctor
  
  attr_accessible :day, :start, :stop, :clinic_doctor_id
  
  validates :clinic_doctor, :presence => true
  validate :start_stop
  validate :bilocation

  before_validation :fix_date

  private
    def start_stop
      errors.add(:start, "sholudn't be greater or equal than #{:stop}") if self.start >= self.stop
    end
    
    def bilocation
      errors.add(:doctor, "can't bilocate") if WorkPlan.joins(:clinic_doctor).where('doctor_id = ?', self.clinic_doctor.doctor_id).where('day = ?', self.day).where('work_plans.id != ?', self.id).where('(? BETWEEN start AND stop) OR (? BETWEEN start AND stop)', self.start , self.stop).exists?
    end

    def fix_date
      self.start = self.start.change(:year => 2000)
      self.stop = self.stop.change(:year => 2000)
    end
end
