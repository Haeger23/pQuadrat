# encoding: UTF-8

class UserProject < Model

  belongs_to :project
  belongs_to :user

  validates_presence_of :project, :user
  validates_numericality_of :weight, :only_integer => true
  validates_uniqueness_of :user_id, :scope => :project_id, :message => "The user has already this project"

end