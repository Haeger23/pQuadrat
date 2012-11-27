# encoding: UTF-8

class UserProject < Model
  belongs_to :project
  belongs_to :user
end