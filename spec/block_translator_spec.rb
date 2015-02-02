require_relative './spec_helper.rb'

describe Sreader::BlockTranslator do

  subject { Sreader::BlockTranslator }

  let(:empty_fn) { proc {} }

  let(:simple1_standard_form) do
    [[:one], [:two], [:three]]
  end

  let(:simple2_standard_form) do
    [[:method1, empty_fn], [:method2, String], [:method3, 42]]
  end

  let(:empty_standard_form) do
    []
  end

  let(:internal_block_standard_form) do
    [[:m, empty_fn]]
  end

  describe "Initialize by dsl" do

    let(:simple1_dsl) do
      proc do 
        one
        two
        three
      end
    end

    let(:empty_dsl) do
      empty_fn
    end

    let(:simple2_dsl) do
      proc do |fn| 
        proc do
          method1 fn
          method2 String
          method3 42
        end
      end.call(empty_fn)
    end

    let(:internal_block_dsl) do
      proc do |fn| 
        proc do 
          m(&fn)
        end
      end.call(empty_fn)
    end
    
    [
      :simple1, 
      :simple2, 
      :empty,
      :internal_block
    ].each do |test|
      it "should correcly translate dsl (#{test}) to standard form" do     
        container = eval("#{test}_dsl")
        answer = eval("#{test}_standard_form")
        subject.new(&container).standard_form.must_equal answer
      end
    end

  end
end
