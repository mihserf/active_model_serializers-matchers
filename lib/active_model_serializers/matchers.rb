module ActiveModel
  module Serializers
    module Matchers
      class Root
        attr_accessor :name, :actual

        def initialize(name = true)
          @name = name
        end

        def matches?(actual)
          @actual = actual

          serializer._root == name
        end

        def description
          "have attribute #{name}"
        end

        def failure_message
          %Q{expected "#{actual._root}" to be "#{name}", but it wasn't}
        end

        def failure_message_when_negated
          %Q{expected "#{actual._root}" to be "#{name}", but it was}
        end

        private
        def serializer
          if actual.is_a?(Class)
            actual
          else
            actual.class
          end
        end
      end

      def include_root(key = nil)
        Root.new key
      end

      class Embed
        attr_accessor :expected, :actual

        def initialize(expected)
          @expected = expected
        end

        def matches?(actual)
          @actual = actual

          serializer.has_many :test_embeds
          association.respond_to?("embed_#{expected}") && association.public_send("embed_#{expected}")
        end

        def description
          "embed #{name}"
        end

        def failure_message
          %Q{expected embed to be "#{expected}", but it wasn't}
        end

        def failure_message_when_negated
          %Q{expected embed not to be "#{expected}", but it was}
        end

        private
        def serializer
          if actual.is_a?(Class)
            actual
          else
            actual.class
          end
        end

        def association
          serializer._associations.values.first
        end
      end

      def embed(value)
        Embed.new value
      end

      class HaveAttribute
        attr_accessor :name, :actual

        def initialize(name)
          @name = name
        end

        def matches?(actual)
          @actual = actual

          attributes.include?(name)
        end

        def description
          "have attribute #{name}"
        end

        def failure_message
          %Q{expected #{actual.inspect} to include "#{name}", but it did not}
        end

        def failure_message_when_negated
          %Q{expected #{actual.inspect} to not include: "#{name}", but it did}
        end

        private
        def serializer
          if actual.is_a?(Class)
            actual
          else
            actual.class
          end
        end

        def attributes
          serializer._attributes
        end
      end

      def have_attribute(name)
        HaveAttribute.new name
      end

      class AssociationMatcher
        attr_accessor :name, :actual, :key

        def initialize(name)
          @name = name
        end

        def matches?(actual)
          @actual = actual

          matched_association = associations.select do |assc|
            assc.name == name
          end.first

          return false unless matched_association

          if key
            return false if matched_association.key != key
          end

          true
        end

        def as(value)
          self.key = value
          self
        end

        def description
          "have attribute #{name}"
        end

        def failure_message
          %Q{expected #{actual.inspect} to include a "#{name}" association, but it did not}
        end

        def failure_message_when_negated
          %Q{expected #{actual.inspect} to not include a "#{name}" association, but it did}
        end

        private
        def serializer
          if actual.is_a?(Class)
            actual
          else
            actual.class
          end
        end

        def associations
          serializer._associations
        end
      end

      def have_many(name)
        AssociationMatcher.new(name)
      end
      alias :have_one :have_many
    end
  end
end
