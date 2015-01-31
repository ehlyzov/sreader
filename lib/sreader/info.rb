require 'set'

module Sreader
  module Info    
    extend self

    @@factories = Set.new([:array, :dict])    

    def add_factory factory
      @@factories.add(factory)
    end
    
    def factories
      @@factories
    end
  end
end
