class Jisx0402::Tree
  class Root
    def initialize
      @root_node = Node.new
    end

    def []=(key, val)
      chars = key.chars
      @root_node.insert(chars.shift, chars, val)
    end

    def [](key)
      chars = key.chars
      @root_node.search(chars.shift, chars)
    end

    def values
      @root_node.values
    end
  end

  class Node
    attr_accessor :value

    def initialize
      @data = {}
      @value = nil
    end

    def insert(key, remain, val)
      @data[key] ||= Node.new
      if remain.empty?
        @data[key].value = val
      else
        @data[key].insert(remain.shift, remain, val)
      end
    end

    def search(key, remain)
      return nil unless @data[key]
      if remain.empty?
        @data[key].values
      else
        @data[key].search(remain.shift, remain)
      end
    end

    def values
      [value, *@data.values.map(&:values)].compact
    end
  end
end
