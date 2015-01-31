require_relative '../sreader.rb'
require_relative 'form'

module Sreader
  module DSL
    def defstruct(name, resolver:, container:, reader: )
      define_method(name) do |&block| 
        sf = Sreader::BlockTranslator.new(&block).standard_form
        Class.new(Sreader::Form).tap do |klass| 
          klass.instance_variable_set("@resolver", resolver.new(sf, container))
          klass.instance_variable_set("@reader", reader)
          klass.instance_eval do
            def_delegators :@container, *sf.map(&:first)
          end
        end
      end
    end

    extend self
    
    defstruct(
      :array, 
      resolver: Sreader::FnResolver, 
      container: Sreader::Factories::StructFactory,
      reader: Sreader::Readers::ArrayReader)

    defstruct(
      :dict, 
      resolver: Sreader::FnResolver, 
      container: Sreader::Factories::StructFactory,
      reader: Sreader::Readers::HashReader)
  end
end
