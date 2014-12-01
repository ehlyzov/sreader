require_relative 'factories/struct_factory'
require_relative 'inspector'

module Sreader
  module DSL    
    def struct(&block)
      Factories::StructFactory.gen_class(
        Inspector.new.tap do |klass|
          klass.instance_eval &block
        end
      )
    end
  end
end
