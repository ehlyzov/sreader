require 'date'
require_relative './spec_helper.rb'

describe Sreader::FnResolver do

  let(:container_factory) do
    Sreader::Factories::StructFactory
  end

  let(:no_fn) do
    [[:method]]
  end

  let(:evaluable) do
    c = Class.new.new
    c.define_singleton_method(:to_proc, -> { proc { 42 }})
    [[:answer, c]]
  end

  let(:struct) do
    Struct.new(:klass)
  end

  let(:klass) do
    [[:struct, struct]]
  end

  let(:enumerable) do
    [[:array, [:to_s]]]
  end

  def resolver(sform)
     Sreader::FnResolver.new(sform, container_klass)
  end

  def reader(data)
    Sreader::Readers::ArrayReader.new(data)
  end

  def resolve(sform, data)
    resolver(sform).resolve(reader(data))
  end

  it "should return raw value if there is not transformation" do
    resolve(no_fn, [:test]).method.must_equal :test
  end

  it "should convert to proc if it is possible and apply it" do
    resolve(evaluable, ['question']).answer.must_equal 42
  end

  it "should use Class#initialize as proc if class given" do
    resolve(klass, [42]).struct.class.must_be :<=, Struct
  end

  it "should convert enumerable to to_proc" do
    resolve(enumerable, [[1, 2, 3]]).array.must_equal ['1', '2', '3']
  end

end
