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
    class CBAttributeHandler < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef
      handles method_call(:default)
      handles method_call(:override)
      handles method_call(:set)
      
      def process
        path_arr = parser.file.to_s.split('/')
        if path_arr.include?('metadata.rb')
          namespace = find_cookbook(path_arr[path_arr.index('metadata.rb') - 1])
	elsif path_arr.include?('attributes')
	  namespace = find_cookbook(path_arr[path_arr.index('attributes') - 1])
        end
      
        log.debug "Statement inspect: #{statement.inspect}"
        name = statement.parameters.first.jump(:string_content, :ident).source
        attrib_obj = AttributeObject.new(namespace, name) do |attrib|
          attrib.source     = statement.source
          attrib.scope      = :instance
          attrib.docstring  = statement.comments
          attrib.add_file(statement.file, statement.line)
        end
        statement.source.split(%r{,\s*:}).each do |param|
          insert_params(attrib_obj, param)
        end
        log.info "Creating [CBAttribute] #{attrib_obj.name} => #{attrib_obj.namespace}"
      end
    
      def insert_params(attrib, param)
        if param =~ /=>/
          args = param.split(%r{\s*=>\s*})
          case args[0]
          when "default"
            attrib.default = args[1]
          when "kind_of"
            attrib.kind_of = args[1]
          when "required"
            attrib.required = args[1]
          when "regex"
            attrib.regex = args[1]
          when "equal_to"
            attrib.equal_to = args[1]
          when "name_attribute"
            attrib.name_attribute = args[1]
          when "callbacks"
            attrib.callbacks = args[1]
          when "respond_to"
            attrib.respond_to = args[1]
          when "display_name"
            attrib.display_name = args[1]
          when "description"
            attrib.description = args[1]
          when "recipes"
            attrib.recipes = args[1]
          when "choice"
            attrib.choice = args[1]
          end
        end
      end
    end
  end
end
