# encoding: UTF-8

class Model < ActiveRecord::Base
  self.abstract_class = true

  def to_s
    self.id
  end

  def self.create_with_hash!(hash, *filter)
    model = self.new
    model.update_with_hash!(hash, *filter)
    model
  end

  def self.create_with_hash(hash, *filter)
    model = self.new
    model.update_with_hash(hash, *filter)
    model
  end

  def self.new_with_hash!(hash, *filter)
    model = self.new
    model.fill_with_hash!(hash, *filter)
    model
  end

  def self.new_with_hash(hash, *filter)
    model = self.new
    model.fill_with_hash(hash, *filter)
    model
  end

  def fill_with_hash(hash, *filter)
    hash.select {|k,v| filter.include?(k) }.each do |k,v|
      send(k.to_s + '=', v)
    end
    self
  end

  def update_with_hash!(hash, *filter)
    fill_with_hash(hash, *filter)
    save!
    self
  end

  def update_with_hash(hash, *filter)
    fill_with_hash(hash, *filter)
    save
    self
  end

  def self.validators_as_hash *filter
    columns = {}
    cols = self.column_names
    unless filter.empty?
      cols = cols.select {|k| filter.include?(k)}
    end
    cols.each do |column|
      columns[column] = validators_as_hash_on(column)
    end
    columns
  end

  def self.validators_as_hash_on(column)
    validators = {}
    self.validators_on(column).each do |validator|
      validators[validator.kind] = validator.options.empty? ? true : validator.options
    end
    validators
  end

end