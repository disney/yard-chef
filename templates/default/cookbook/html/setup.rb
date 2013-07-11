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

include T('default/module')

def init
  sections.push :cookbook_title, [
                  :docstring,
                  :generated_docs,
                  [
                    :recipes,
		    :attributes,
                    T('resource'),
                    T('provider'),
                    T('resource_attribute'),
                    :definitions,
                    :libraries,
                    :element_details,
                    [T('recipe'), T('cookbook_attribute'), T('action'), T('definition')]
                  ]
                ]
  @libraries = YARD::Registry.all(:module)
end

def namespace_to_node(attr)
  ns = attr.namespace.to_s.split("::")[2..-1].join("::")
  #ns.gsub!(/::/,"")
  if ns == ""
    "node[:#{attr.name.downcase}]"
  else 
    "node[:#{ns.gsub(/::/,"][:").downcase}][:#{attr.name.downcase}]"
  end
end

def namespace_to_anchor(attr)
  ns = attr.namespace.to_s.split("::")[2..-1].join("__")
  if ns == ""
    "attribute__#{attr.name.downcase}"
  else
    "attribute__#{ns.downcase}__#{attr.name.downcase}"
  end
end

def find_library(library_file)
  libs = []
  @libraries.each do |library|
    libs.push(library) if library.file == library_file
  end
  libs
end
