require_relative 'block_translator'
require 'forwardable'

module Sreader

  class Form    
    extend Forwardable

    def initialize(data)
      @container = self.class.resolver.resolve(
        self.class.reader.new(data))
    end

    class << self

      def ==(other)
        other.standard_form == self.standard_form
      end

      def standard_form
        @resolver.standard_form  
      end       

      def resolver
        @resolver
      end

      def reader
        @reader
      end
    end
  end
end
