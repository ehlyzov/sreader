require_relative 'base_reader'

module Sreader
  module Readers
    class HashReader < BaseReader
      def read(key)
        yield @data[key]
      end
    end 
  end
end
