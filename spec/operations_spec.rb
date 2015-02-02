require_relative './spec_helper.rb'
include Sreader::DSL

describe 'equality' do
  subject do
    array do
      id
      name
    end
  end

  let(:a1) do
    array do
      id
      name
    end
  end

  let(:a2) do
    array do
      name
      id
    end
  end

  let(:a3) do
    array do
      id
      name
      gender
    end
  end

  it "should be equal with other struct if it has same keys in the same order" do
    subject.must_equal a1    
  end

  it "should not be equal if order of keys is different" do
    subject.wont_equal a2
  end

  it "should not be equal if keys' sets are different" do
    subject.wont_equal a3
  end
end
