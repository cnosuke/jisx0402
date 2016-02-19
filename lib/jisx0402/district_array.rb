class Jisx0402::DistrictArray < Array
  def self.wrap(ary)
    this = new
    ary.map{|e| this << ary }
    return this
  end

  def zipcodes
    self.flatten.map(&:zipcodes).flatten.uniq
  end
end
