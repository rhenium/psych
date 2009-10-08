require 'psych/visitable'

require 'psych/nodes/node'
require 'psych/nodes/stream'
require 'psych/nodes/document'
require 'psych/nodes/sequence'
require 'psych/nodes/scalar'
require 'psych/nodes/mapping'
require 'psych/nodes/alias'

require 'psych/visitors'

require 'psych/handler'
require 'psych/tree_builder'
require 'psych/parser'
require 'psych/ruby'
require 'psych/psych'

module Psych
  VERSION         = '1.0.0'
  LIBYAML_VERSION = Psych.libyaml_version.join '.'

  ###
  # Load +yaml+ in to a Ruby data structure
  def self.load yaml
    parse(yaml).to_ruby
  end

  ###
  # Parse a YAML string.  Returns the first object of a YAML parse tree
  def self.parse yaml
    yaml_ast(yaml).children.first.children.first
  end

  ###
  # Parse a YAML string in +yaml+.  Returns the AST for the YAML parse tree.
  def self.yaml_ast yaml
    parser = Psych::Parser.new(TreeBuilder.new)
    parser.parse yaml
    parser.handler.root
  end

  ###
  # Dump object +o+ to a YAML string
  def self.dump o
    o.to_yaml
  end

  ###
  # Load multiple documents given in +yaml+, yielding each document to
  # the block provided.
  def self.load_documents yaml, &block
    yaml_ast(yaml).children.each do |child|
      block.call child.to_ruby
    end
  end
end
