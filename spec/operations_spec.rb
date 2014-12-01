require_relative './spec_helper.rb'

describe 'equality' do
  subject do
    struct do
      id
      name
    end
  end

  let(:test1) do
    struct do
      id
      name
    end
  end

  let(:test2) do
    struct do
      name
      id
    end
  end

  let(:test3) do
    struct do
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
