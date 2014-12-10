require_relative './spec_helper.rb'

describe "transform" do
  let(:source) do
    array do
      age
      name
    end
  end

  let(:target) do
    array do
      name
      age
    end
  end

  subject do
    (source >> target).call(source.new(['30', 'eugene']))
  end

  it "should produce expected class" do
    subject.must_be_kind_of( target )
  end

  it "should toss data properly" do
    subject.age.must_equal '30'
  end
end

describe 'equality' do
  subject do
    array do
      id
      name
    end
  end

  let(:test1) do
    array do
      id
      name
    end
  end

  let(:test2) do
    array do
      name
      id
    end
  end

  let(:test3) do
    array do
      id
      name
      gender
    end
  end

  it "should be equal with other struct if it has same keys in the same order" do
    subject.must_equal test1    
  end

  it "should not be equal if order of keys is different" do
    subject.wont_equal test2
  end

  it "should not be equal if keys' sets are different" do
    subject.wont_equal test3
  end
end
