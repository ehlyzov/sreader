require_relative 'factories/struct_factory'
require_relative 'inspector'

module Sreader
  module DSL
    def array(&block)
      Factories::StructFactory.generator(
        :array,
        inspector: reader(block)
      )
    end

    def dict(&block)
      Factories::StructFactory.generator(
        :dict,
        inspector: reader(block)
      )
    end

    private

    def reader(context)
      Inspector.new.tap do |klass|
        klass.instance_eval &context
      end
    end
  end
end
