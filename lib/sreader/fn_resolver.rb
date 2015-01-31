module Sreader
  class FnResolver

    attr_reader :standard_form

    def initialize(standard_form, container_factory)
      @standard_form = standard_form
      @container_factory = container_factory
    end

    def resolve(reader)
      @standard_form.reduce(container) do |res, (name, evaluable)|
        reader.read(name) do |value| 
          res[name] = ((fn = deduce_fn(evaluable)) ? fn.call(value) : value)
        end
        res
      end
    end

    private 

    def container
      @container_factory[*@standard_form.map(&:first)].new
    end
    
    def deduce_fn(evaluable)
      case evaluable
      when proc {|x| x.respond_to?(:to_proc)} then evaluable.to_proc
      when Enumerable 
        if evaluable.count == 1 && fn = deduce_fn(evaluable.first)
          ->(x) { x.map { |e| fn.call(e) }}
        end
      when Class then ->(x) { evaluable.new(x) }
      end
    end
  end
end


