class Model < ActiveRecord::Base
  self.abstract_class = true

  def update_with_hash!(hash, *filter)
    hash.select {|k,v| filter.include?(k.to_sym) }.each do |k,v|
      send(k + '=', v)
    end
    save!
    self
  end

  def update_with_hash(hash, *filter)
    begin
      update_with_hash!(hash, *filter)
    rescue
      false
    end
  end

end