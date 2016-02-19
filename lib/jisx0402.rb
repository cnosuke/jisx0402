require "jisx0402/version"
require 'jisx0402/district_array'
require 'msgpack'

module Jisx0402
  class << self
    def search
      data
    end

    def search(word, by: nil)
      way = %w(code prefecture prefecture_yomi district district_yomi full full_yomi)

      if by
        result = data.select do |d|
          d.at(way.index(by.to_s)) =~ /#{word}/
        end
        if result.size == 1
          return Code.new(result.first)
        else
          Jisx0402::DistrictArray.wrap(
            result.map{|r| Code.new(r) }
          )
        end
      else
        result = way.map do |w|
          search(word, by: w)
        end
        result = result.flatten.uniq{|e| e.code }
        if result.size == 1
          return result.first
        else
          return Jisx0402::DistrictArray.wrap(result)
        end
      end
    end

    def data
      @@data ||= open_msgpack_data('jisx0402.msgpack')
    end

    def zipcodes_table
      @@zipcodes_table ||= open_msgpack_data('jisx0402_to_zipcode.msgpack')
    end

    def open_msgpack_data(fname)
      MessagePack.unpack(
        open(File.expand_path("../data/#{fname}", __FILE__)).read
      )
    end
  end

  class Code
    def initialize(row)
      @row = row
    end

    def code
      @row[0]
    end

    def code_without_checkdigit
      @row[0][0..-2]
    end

    def prefecture(hiragana: false)
      hiragana ? @row[2] : @row[1]
    end

    def district(hiragana: false)
      hiragana ? @row[4] : @row[3]
    end

    def full(hiragana: false)
      hiragana ? @row[6] : @row[5]
    end

    def first
      self #compatible for Array#first
    end

    def zipcodes
      Jisx0402.zipcodes_table[code_without_checkdigit]
    end
  end
end
