# encoding: UTF-8

class Category < Model

  has_many :skills

  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of     :name, :with => /^[-a-z0-9_äöü\+ ]+$/i
  validates_presence_of :name
  validates_length_of :name, :minimum => 4

  def name=(value)
    super
    write_attribute(:url, value.downcase.gsub(/\W+/, "_"))
  end

end