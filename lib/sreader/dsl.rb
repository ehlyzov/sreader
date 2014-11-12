module Sreader

  module DSL
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
        @methods.push Method.new(name, fn ? fn.to_proc : nil)
      end
    end

    class StructFactory
      def self.gen_class( inspector )
        Class.new.tap do |klass|
          klass.class_eval do
            inspector.methods_names.each do |name|
              attr_accessor name
            end

            define_method(:initialize, &(
              ->(names, fns) do
                ->( obj ) do
                  raise ArgumentError if (obj.count > names.size)
                  names.zip(obj, fns).each do |name, value, fn|
                    instance_variable_set("@#{name}".to_sym, fn ? fn.call(value) : value)
                  end
                end
              end.call(inspector.methods_names, inspector.methods.map(&:fn))
            ))
          end
        end
      end
    end

    def self.struct(&block)
      StructFactory.gen_class(
        Inspector.new.tap do |klass|
          klass.instance_eval &block
        end
      )
    end
  end

end
