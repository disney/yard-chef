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

module YARD::CodeObjects
  module Chef
    class ProviderObject < ChefObject
      register_element :provider
      attr_accessor :name, :resource

      def initialize(namespace, name)
        super(namespace, name)
      end

      def long_name
        name = ''
        if @name.to_s =~ /_/
          @name.to_s.split('_').each do |str|
            name << str.to_s.capitalize
          end
        else
          name = @name.to_s.capitalize
        end
        "#{@namespace}::#{name}"
      end

      def map_resource(file)
        file_handle = File.open(File.expand_path(file), 'r')
        file_handle.readlines.each do |line|
          if line =~ /#\s@resource/
            resource_name = line.split(%r{@resource })[1]
            @resource = self.class.superclass.register(RESOURCE, resource_name, :resource)
            @resource.providers.push(self)
            break
          end
        end
      end
    end

    PROVIDER = ChefObject.register(CHEF, 'Provider', :provider)
  end
end
