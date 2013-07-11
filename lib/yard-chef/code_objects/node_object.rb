require 'yard'

module YARD::CodeObjects
  module Chef
    # A NodeObject represents the root Chef object during a Chef run.  It can have attributes associated with it, which
    # represents the extent of yard-chef's interest in it.  See http://wiki.opscode.com/display/chef/Attributes
    class NodeObject < ChefObject
      register_element :node

      # Creates a new instance of DefinitionObject.
      # @param [NamespaceObject] namespace namespace to which the definition must belong.
      # @param [String] name name of the definition.
      def initialize(namespace, name)
        super(namespace, name)
      end
    end
  end
end
