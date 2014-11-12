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

    def struct(&block)
      StructFactory.gen_class(
        Inspector.new.tap do |klass|
          klass.instance_eval &block
        end
      )
    end
  end

end
