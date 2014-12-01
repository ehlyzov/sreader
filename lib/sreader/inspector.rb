module Sreader
  class Inspector

    class Method
      attr_accessor :name
      attr_accessor :fn

      def initialize name, fn
        @name = name
        @fn = fn
      end

      def to_ary
        [name, fn]
      end
    end

    attr_reader :methods

    def initialize
      @methods = []
    end

    def methods_names
      methods.map(&:name)
    end

    def method_missing(name, fn = nil)
      @methods.push Method.new(name, deduce_fn(fn))
    end

    private 

    def deduce_fn( obj )
      responds = ->(m) { ->(x) { x.respond_to?(m) } }
      case obj
      when responds[:to_proc] then obj.to_proc
      when Enumerable 
        if obj.count == 1 && fn = deduce_fn(obj.first)
          ->(x) { x.map { |e| fn.call(e)  }}
        else
          nil
        end
      when Class then ->(x) { obj.new(x) }
      else nil
      end
    end
  end
end
