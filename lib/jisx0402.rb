require "jisx0402/version"
require 'csv'

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
          return result.map{|r| Code.new(r) }
        end
      else
        result = way.map do |w|
          search(word, by: w)
        end
        result = result.flatten.uniq{|e| e.code }
        if result.size == 1
          return result.first
        else
          return result
        end
      end
    end

    def data
      @@data ||= CSV.parse(open(File.expand_path('../data/data.csv', __FILE__)).read)
    end
  end

  class Code
    def initialize(row)
      @row = row
    end

    def code
      @row[0]
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
  end
end
