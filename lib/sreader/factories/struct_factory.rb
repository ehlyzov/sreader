module Sreader
  module Factories
    class StructFactory
      def self.[](*args)
        Class.new(Struct.new(*args)).tap do |klass| 
          klass.instance_eval do
            # extensions
          end
        end
      end
    end
  end
end
