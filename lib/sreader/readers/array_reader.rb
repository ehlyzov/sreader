require_relative 'base_reader'

module Sreader
  module Readers
    class ArrayReader < BaseReader
      def read(key)
        if @data.empty?
          raise RangeError
        else  
          yield @data.shift
        end
      end
    end 
  end
end
