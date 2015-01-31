module Sreader
  class BlockTranslator

    class Sandbox
      def initialize(&block)
        @lines = []
        if block_given?
          instance_eval(&block)        
        end
      end

      def to_ary
        @lines
      end

      def method_missing(*args, &block)
        @lines.push [*args, *block]
      end
    end

    attr_reader :standard_form

    def initialize &block
      @standard_form = Sandbox.new(&block).to_ary
    end
  end
end


