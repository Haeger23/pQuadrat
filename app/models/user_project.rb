# encoding: UTF-8

class UserProject < Model

  belongs_to :project
  belongs_to :user

  validates_presence_of :project, :user

end