require 'spec_helper'
require 'active_support/core_ext/string/inflections'

describe ActiveModel::Serializers::Matchers do
  include ActiveModel::Serializers::Matchers

  it "should be false if the serializer does not have an attribute" do
    serializer = Class.new ActiveModel::Serializer do
      attributes :foo
    end

    expect(serializer).to_not have_attribute :bar
    expect(serializer).to have_attribute :foo
  end

  it "should match the embed setting" do
    serializer = Class.new ActiveModel::Serializer do
      embed :ids
    end

    expect(serializer).to embed(:ids)
    expect(serializer).to_not embed(:objects)
  end
  end

  describe "The root key" do
    it "should match the root setting" do
      serializer = Class.new ActiveModel::Serializer do

      end

      expect(serializer).to include_root
    end

    it "should be able to match a specific key" do
      serializer = Class.new ActiveModel::Serializer do
        root :foo
      end

      expect(serializer).to include_root(:foo)
      expect(serializer).to_not include_root(:bar)
    end
  end

  describe "Associations" do
    it "should work with has_many" do
      serializer = Class.new ActiveModel::Serializer do
        has_many :foos
      end

      expect(serializer).to have_many(:foos)
      expect(serializer).to_not have_many(:bars)
    end

    it "should work with has_one" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foo
      end

      expect(serializer).to have_one(:foo)
      expect(serializer).to_not have_one(:bar)
    end

    it "should work with has_one key options" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foo, :key => :bar
      end

      expect(serializer).to have_one(:foo).as(:bar)
      expect(serializer).to have_one(:foo)
      expect(serializer).to_not have_one(:foo).as(:qux)
    end

    it "should work with has_many key options" do
      serializer = Class.new ActiveModel::Serializer do
        has_one :foos, :key => :bars
      end

      expect(serializer).to have_one(:foos).as(:bars)
      expect(serializer).to have_one(:foos)
      expect(serializer).to_not have_one(:foos).as(:qux)
    end
  end
end
