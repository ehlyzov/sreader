module Sreader
  module Factories
    module StructFactory

      def self.strategies
        @@strategies ||= {
          dict: ->(options) do
            inspector = options[:inspector]
            eigen_keys = inspector.methods_names
            fns = inspector.methods.map(&:fn)
            {
              triples: ->(obj) do
                eigen_keys.zip(obj.to_h.values_at(*eigen_keys), fns)
              end,
              gen_class_name: -> do
                'H' + Digest::SHA1.hexdigest( eigen_keys.join(' '))
              end,
              validate: ->(obj) do
                raise ArgumentError unless (eigen_keys - obj.to_h.keys).empty?
              end
            }
          end,
          array: ->(options) do
            inspector = options[:inspector]
            eigen_keys = inspector.methods_names
            fns = inspector.methods.map(&:fn)
            {
              triples: ->(obj) do
                eigen_keys.zip(obj.to_a, fns)
              end,
              gen_class_name: -> do
                'A' + Digest::SHA1.hexdigest( eigen_keys.join(' '))
              end,
              validate: ->(obj) do
                raise ArgumentError if (obj.to_a.size < eigen_keys.size)
              end
            }
          end
        }
      end

      def self.generator(type, options)
        strategy = self.strategies[type].call(options)
        class_name = strategy[:gen_class_name].call
        triples = strategy[:triples]
        validate = strategy[:validate]
        operations = {
          :>> => ->(other) do
            ->(instance) do
              other.new do |key|
                instance.send(key)
              end
            end
          end
        }
        if const_defined?(class_name)
          const_get(class_name)
        else
          Class.new(Struct.new(*options[:inspector].methods_names)).tap do |klass|
            const_set(class_name, klass)
          end.tap do |klass|
            klass.class_eval do
              define_singleton_method :source, &(->(source) { -> { source }}.call(options[:inspector]))

              operations.each do |op, proc|
                define_singleton_method op, &proc
              end

              define_method :triples, &triples
              define_method :validate, &validate

              define_method :setup_variables, &(
                ->(triples) do
                  ->(obj) do
                    triples.call( obj ).each do |name, value, fn|
                      self.send("#{name}=".to_sym, fn ? fn.call(value) : value)
                    end
                  end
                end.call(triples)
              )

              def initialize(obj = nil)
                if block_given?
                  self.class.source.methods_names.each do |name|
                    self.send("#{name}=".to_sym, yield(name))
                  end
                else
                  validate(obj)
                  setup_variables(obj)
                end
              end
            end
            if extra = strategy[:extra]
              klass.class_eval &extra
            end
          end
        end
      end
    end
  end
end
