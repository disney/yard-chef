# Copyright (c) 2012 RightScale, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'yard'

module YARD::Handlers
  module Chef
    class CookbookAttributeHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:default)
      handles method_call(:default_unless)
      handles method_call(:override)
      handles method_call(:set)
      handles method_call(:set_unless)
      handles :assign
      
      def process
        path_arr = parser.file.to_s.split('/')
	if path_arr.include?('attributes') and statement.source =~ /node.+=.+/
          # register cookbook if it hasn't already been registered
	  #puts "CB_SOURCE = #{statement.source}"
          cookbook_name = path_arr[path_arr.find_index('attributes')-1] # cookbookname/attributes/FILE.rb
          cookbook_obj = ChefObject.register(CHEF, cookbook_name, :cookbook)
          cookbook_obj.add_file(statement.file)
	  node_obj = ChefObject.register(:root, "node", :node)
          node_obj.add_file(statement.file)
	name = nil
	names = []
	statement.source.scan(/(\[[\[\]\'\"\:\w]+) = .*/) { |ad| ad[0].scan(/\[([:\'\"\-_\w]+?)\]( =){0}/) { |m| names.push(m[0].gsub(/[:\'\"]/, "")) } }
	name = names.join("::")
	#/(\[([:'"\-_\w]+)\])/.match(statement.source) { |m| name = m[1].gsub(/['"]?\]\[[:'"]?/,"::").gsub(/(\[[:'"]|['"\]])/,'') }

        top_obj = nil
	leaf = name.split("::").last
        name.split("::").each do |na| 
	  puts "Taking #{na} now with source: #{statement.source} and comments: #{statement.comments}"
          attr_obj = CookbookAttributeObject.register(node_obj.nil? ? node_obj : top_obj, na, :cookbook_attribute)
	  if na == leaf
            attr_obj.source = statement.source
            attr_obj.docstring = statement.comments
	    attr_obj.cookbook = cookbook_obj.name
	  end
          attr_obj.add_file(statement.file, statement.line)
	  cookbook_obj.attributes.push(attr_obj) unless cookbook_obj.attributes.include?(attr_obj)
          top_obj = attr_obj.dup()
        end
	else
	  return
        end
      
        log.debug "Statement inspect: #{statement.inspect}"
	# this logic needs to be re-done.
        #name = statement.parameters.first.jump(:string_content, :ident).source
        #statement.source.split(%r{,\s*:}).each do |param|
        #  insert_params(attrib_obj, param)
        #end
        #log.info "Creating [CookbookAttribute] #{attr_obj.name} => #{attr_obj.namespace}"
      end
    
    end
  end
end
