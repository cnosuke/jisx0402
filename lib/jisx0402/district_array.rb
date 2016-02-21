class Jisx0402::DistrictArray < Array
  def self.wrap(ary)
    this = new
    ary.flatten.map{|e| this << e }
    return this
  end

  def zipcodes
    self.map(&:zipcodes).flatten.uniq.compact
  end
end
