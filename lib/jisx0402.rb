require "jisx0402/version"
require 'jisx0402/district_array'
require 'jisx0402/tree'
require 'msgpack'
require 'pry'

module Jisx0402
  class << self
    TREE_INDEX_KEYS = %i(code full)
    def search
      data
    end

    def forward_match_by_full(chunk)
      forward_match_by(:full, chunk)
    end

    def forward_match_by_code(chunk)
      forward_match_by(:code, chunk)
    end

    def forward_match_by(by, chunk)
      ary = data_trees_index[by.to_sym][chunk.to_s] || []
      return Jisx0402::DistrictArray.wrap(ary)
    end

    def match_by_zipcode(zipcode)
      zipcode_to_jisx0402_table[zipcode]
    end

    def search(word, by: nil)
      if by
        result = data.select { |d| d.match?(word, by) }
      else
        result = Code::ATTRS_INDEX.map { |w| search(word, by: w) }.uniq.flatten
      end

      if result.size == 1
        return result.first
      else
        Jisx0402::DistrictArray.wrap(result)
      end
    end

    def data
      @@data ||= open_msgpack_data('jisx0402.msgpack').map do |d|
        Code.new(d)
      end
    end

    def data_trees_index
      @@data_trees_index ||= begin
        TREE_INDEX_KEYS.map.with_object({}) do |idx_key, h|
          h[idx_key] = Jisx0402::Tree::Root.new
          data.each { |d| h[idx_key][d.send(idx_key.to_sym)] = d }
        end
      end
    end

    def zipcode_to_jisx0402_table
      @@zipcode_to_jisx0402_table ||= begin
        jisx0402_to_zipcode_table.map.with_object({}) do |(jisx0402, zipcodes), hash|
          zipcodes.map do |zipcode|
            hash[zipcode] = forward_match_by_code(jisx0402).first
          end

          hash
        end
      end
    end

    def jisx0402_to_zipcode_table
      @@jisx0402_to_zipcode_table ||= open_msgpack_data('jisx0402_to_zipcode.msgpack')
    end

    def open_msgpack_data(fname)
      MessagePack.unpack(
        open(File.expand_path("../data/#{fname}", __FILE__)).read
      )
    end
  end

  class Code
    ATTRS_INDEX = %w(
      code
      prefecture
      prefecture_yomi
      district
      district_yomi
      full
      full_yomi
    ).freeze

    def initialize(row)
      @row = row
    end

    def match?(word, by)
      @row.at(ATTRS_INDEX.index(by.to_s)) =~ /#{word}/
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
      Jisx0402.jisx0402_to_zipcode_table[code_without_checkdigit] || []
    end
  end
end
