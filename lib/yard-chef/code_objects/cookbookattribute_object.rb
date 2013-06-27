require 'yard'

module YARD::CodeObjects
  module Chef
    # A CookbookAttributeObject represents a cookbook-defined node attribute.
    class CookbookAttributeObject < ChefObject
      register_element :cookbook_attribute

      # Creates a new instance of CookbookAttributeObject.
      # @param [NamespaceObject] namespace namespace to which the attribute must belong.
      # @param [String] name name of the attribute.
      def initialize(namespace, name)
        super(namespace, name)
      end
      # convert YARD registry name to Chef node attribute string
        def namespace_to_node
          ns = self.namespace.to_s.split("::")[2..-1].join("::")
          #ns.gsub!(/::/,"")
          if ns == ""
            "node[:#{self.name.downcase}]"
          else
            "node[:#{ns.gsub(/::/,"][:").downcase}][:#{self.name.downcase}]"
          end
        end
    end
  end
end
