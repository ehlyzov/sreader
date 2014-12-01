module Sreader
  module Factories
    module StructFactory

      def self.gen_class_name( eigen_keys )
        'S' + Digest::SHA1.hexdigest( eigen_keys.join(' ') )
      end

      def self.gen_class( inspector )
        eigen_keys = inspector.methods_names
        if const_defined?(class_name = gen_class_name( eigen_keys ))
          const_get(class_name)
        else        
          Class.new.tap do |klass|
            const_set(class_name, klass) 
          end.tap do |klass| 
            klass.class_eval do
              inspector.methods_names.each do |name|
                attr_accessor name
              end

              define_method(:initialize, &(
                ->(names, fns) do
                  ->( obj ) do

                    setup_variables = -> (values) do
                      names.zip(values, fns).each do |name, value, fn| 
                        instance_variable_set("@#{name}".to_sym, fn ? fn.call(value) : value)
                      end
                    end

                    case obj
                    when Hash
                      raise ArgumentError unless (names - obj.keys).empty?
                      setup_variables.call(obj.values)
                    else
                      values = obj.to_a
                      raise ArgumentError if (values.size < names.size)
                      setup_variables.call(values)
                    end
                  end
                end.call(inspector.methods_names, inspector.methods.map(&:fn))
              ))
            end
          end
        end
      end
    end
  end
end
