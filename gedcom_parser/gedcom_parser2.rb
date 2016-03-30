class GedcomParser2
  
  def parse(input)
    root = Node.new(name: "gedcom")
    node_stack = []
    node_stack << root

    input.each_line do |line|
      next if line =~ /^\s*$/
      level, id_or_tag, data = *line.strip.split(/\s+/, 3)
      level = level.to_i

      if id_or_tag =~ /@.+@/ 
        id = id_or_tag
        tag = data.downcase
        content = nil
      else
        tag = id_or_tag.downcase
        content = data
        id = nil
      end
      node = Node.new(name: tag, content: content, id: id)
      while(level <= (node_stack.size - 2)) 
        node_stack.pop
      end
      node_stack.last.add_child(node)
      node_stack << node
    end
    Formatter.new.format(root, 0)
  end
end

class Node
  attr_reader :name, :id, :level, :children, :content

  def initialize(name:, content: nil, id: nil)
    @name = name
    @id = id
    @content = content
    @children = [] 
  end

  def add_child(node)
    @children << node
  end
end

class Formatter
  def format(node, identation_level=0)
    result = ""
    
    #output start tag
    result << "  " * identation_level
    result << "<#{node.name}"
    if node.id
      result << " id=\"#{node.id}\""
    end
    result << ">"

    #output content
    if node.content
      if node.children.any?
        result << "\n"
        result << "  " * (identation_level + 1)
      end
      result << node.content
    end

    node.children.each do |child_node|
      result << "\n"
      result << format(child_node, identation_level + 1)
    end

    #output end tag
    if node.children.any?
      result << "\n"
      result << "  " * identation_level
    end
    result << "</#{node.name}>"

    result
  end
end

