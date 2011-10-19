class Person < ActiveRecord::Base
  has_many :role_appointments, conditions: RoleAppointment::CURRENT_CONDITION

  has_many :roles, through: :role_appointments
  has_many :ministerial_roles, class_name: 'MinisterialRole', through: :role_appointments, source: :role
  has_many :board_member_roles, class_name: 'BoardMemberRole', through: :role_appointments, source: :role

  has_many :organisation_roles, through: :ministerial_roles
  has_many :organisations, through: :organisation_roles

  validates :name, presence: true
end