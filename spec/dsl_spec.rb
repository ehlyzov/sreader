require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/sreader'
require 'pry'
include Sreader

describe DSL, :flat_array do
  subject do
    ::DSL.struct do
      one
      two
      three
    end
  end

  it "should respect order" do
    subject.new([1,2,3]).tap do |s| 
      [ s.one, 
        s.two,
        s.three ].must_equal [1,2,3]
    end
  end

  it "should assign nil to uninitialized values" do
    subject.new([1,2]).three.must_equal nil
  end

  it "should raise exception when array is too big for specification" do
    proc { subject.new([1,2,3,4]) }.must_raise ArgumentError    
  end  
end

describe DSL, :transformation do
  subject do
    ::DSL.struct do
      date :to_sym.to_proc
    end.new(data)
  end

  let(:data) do
    ['18-02-2009']
  end

  it "should use transformation if given" do
    subject.date.must_equal( :'18-02-2009' )
  end
end

describe DSL, :target_class do
  subject do
    ::DSL.struct do
       word Regexp
       number Regexp
    end.new(data)
  end

  let(:data) do
    [ "\\w+", "\\d+"]
  end

  it "should wrap data with given classes" do
     regexp = Regexp.union(subject.word, subject.number)
     "the answer is 42".split.all? do |str| 
       str[ regexp ] 
     end.must_equal true
  end
end

describe DSL, :nested_structures do
  subject do
    ::DSL.struct do
      pairs [(::DSL.struct do
               key
               value
            end)]
    end.new(data)
  end

  let(:data) do
    [[[:key1, :value1], [:key2, :value2]]]
  end

  it "should recognize nested structures" do
    subject.pairs.map do |struct| 
      [struct.key, struct.value]  
    end.to_h.must_equal({key1: :value1, key2: :value2})
  end
end
