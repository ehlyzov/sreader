module Sreader
  module Readers
    class BaseReader
      
      def initialize(data)
        @data = data
      end

      def read(key)
        raise NotImplementedError
      end
    end 
  end
end
