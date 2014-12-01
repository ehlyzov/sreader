require_relative './spec_helper'

include Sreader::DSL

describe :flat_array do
  subject do
    struct do
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
    proc { subject.new([1,2]) }.must_raise ArgumentError
  end

end

describe :transformation do
  subject do
    struct do
      date Date.method(:parse)
    end.new(data)
  end

  let(:data) do
    ['18-02-2009']
  end

  it "should use transformation if given" do
    subject.date.must_equal( Date.parse( '18-02-2009' ) )
  end
end

describe :target_class do
  subject do
    struct do
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

describe :nested_structures do
  subject do
    struct do
      pairs [(struct do
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

describe :hash do
  subject do
    struct do
      id :to_sym
      name
      gender      
      birth Date.method(:parse)
    end.new(data)
  end

  let(:data) do
    {
       id: 'pushkin',
       name: 'Alexander Pushkin',
       gender: 'male',
       birth: '26-05-1799'
    }
  end

  it "should use hash to instantiate structure" do
    subject.id.must_equal :pushkin 
  end

  it "should wrap data with given class" do
    subject.birth.must_equal Date.parse('26-05-1799')
  end

  describe "nested hashes" do
    subject do
      struct do
        id :to_sym
        children [(struct do
            name
            gender
          end)]
      end.new(data)     
    end
    
    let(:data) do
      {
        id: "Tompsons",
        children: [
          { 
            name: 'Elisa',
            gender: 'f'
          },
          ['Mark', 'm']
        ]
      }
    end

    it "should recognize nested structures" do
      subject.children.map(&:gender).must_equal ['f','m']
    end
  end
end
