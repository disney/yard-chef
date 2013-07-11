require 'yard'

module YARD::CodeObjects
  module Chef
    # A CookbookAttributeObject represents a cookbook-defined node attribute.
    class CookbookAttributeObject < ChefObject
      register_element :cookbook_attribute
      attr :cookbook

      # Creates a new instance of CookbookAttributeObject.
      # @param [NamespaceObject] namespace namespace to which the attribute must belong.
      # @param [String] name name of the attribute.
      def initialize(namespace, name)
        super(namespace, name)
      end
      # convert YARD registry name to Chef node attribute string
        def namespace_to_node
	  if namespace =~ /::/
          ns = self.namespace.to_s.split("::")[2..-1].join("::")
	  else
	  ns = namespace.to_s
	  end
          #ns.gsub!(/::/,"")
          if ns == ""
            "node[:#{self.name.downcase}]"
          else
            "node[:#{ns.gsub(/::/,"][:").downcase}][:#{self.name.downcase}]"
          end
        end
	
        # convert the YARD registry name to an HTTP-friendly anchor
	def namespace_to_anchor()
	  if self.namespace.to_s.nil? or self.namespace.to_s == ""
	    "attribute__#{self.name.downcase}"
	  else
	    "attribute__#{self.namespace.to_s.gsub("::","__").downcase}__#{self.name.downcase}"
	  end
	end
    end
  end
end
