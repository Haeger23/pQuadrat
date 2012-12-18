# encoding: UTF-8

class Category < Model

  has_many :skills

  validates_uniqueness_of :url, :case_sensitive => false
  validates_format_of     :name, :with => /^[a-zäöüß][\w+-]+[ ]?([\w+-]+[ ]?)*$/i
  validates_presence_of   :url, :name
  validates_length_of     :name, :minimum => 2

  def name=(value)
    if value
      # trim
      value = value.strip.gsub(/\s/, " ")
      write_attribute(:url, value.gsub(/\W/, "_"))
    end
    super(value)
  end

end