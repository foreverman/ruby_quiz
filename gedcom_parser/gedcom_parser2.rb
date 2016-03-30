class GedcomParser2
  
  def parse(input)
    root = build_tree(input)
    Formatter.new.format(root, 0)
  end

  def build_tree(input)
    root = Node.new(name: "gedcom")
    node_stack = [root]
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
    root
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
    write_start_tag(result, node, identation_level)
    write_content(result, node, identation_level)
    write_child_nodes(result, node, identation_level)
    write_end_tag(result, node, identation_level)
    result
  end

  private
  def write_child_nodes(result, node, identation_level)
    node.children.each do |child_node|
      result << "\n"
      result << format(child_node, identation_level + 1)
    end
  end
  def write_start_tag(result, node, identation_level)
    write_identations(result, identation_level)
    result << "<#{node.name}"
    if node.id
      result << " id=\"#{node.id}\""
    end
    result << ">"
  end

  def write_content(result, node, identation_level)
    if node.content
      if node.children.any?
        result << "\n"
        write_identations(result, identation_level + 1)
      end
      result << node.content
    end
  end

  def write_end_tag(result, node, identation_level)
    if node.children.any?
      result << "\n"
      write_identations(result, identation_level)
    end
    result << "</#{node.name}>"
  end
  
  def write_identations(result, identation_level)
      result << "  " * identation_level
  end
end

