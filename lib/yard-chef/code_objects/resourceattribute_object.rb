require 'yard'

module YARD::CodeObjects
  module Chef
    # A ResourceAttributeObject represents a cookbook-defined node attribute.
    class ResourceAttributeObject < ChefObject
      register_element :resource_attribute

      # Creates a new instance of ResourceAttributeObject.
      # @param [NamespaceObject] namespace namespace to which the attribute must belong.
      # @param [String] name name of the attribute.
      def initialize(namespace, name)
        super(namespace, name)
      end
    end
  end
end
