class GedcomParser
  def parse(input)
    endtags_stack = []
    output = ""
    output += "<gedcom>"
    output += "\n"
    input.each_line do |line|
      level, id_or_tag, data = *line.strip.split(/\s+/, 3)
      level = level.to_i

      #output end tag
      while(level <= (endtags_stack.size - 1))
        output_identation(output, endtags_stack.size)
        output_end_tag(output, endtags_stack.pop)
        output += "\n"
      end

      output_identation(output, level + 1)
      if id_or_tag =~ /@.+@/ 
        id = id_or_tag
        tag = data.downcase
        output += "<#{tag} id=\"#{id}\">"
        output += "\n"
      else
        tag = id_or_tag.downcase
        output += "<#{tag}>"
        output += "\n"
        output_identation(output, level + 2)
        output += data
        output += "\n"
      end
      endtags_stack << tag
    end
    
    #end tags that haven't got chances to do so
    while(endtags_stack.any?)
      output_identation(output, endtags_stack.size)
      output_end_tag(output, endtags_stack.pop)
      output += "\n"
    end
    output += "</gedcom>"
  end

  private
  def output_end_tag(output, tag)
    output << "</#{tag}>"
  end

  def output_identation(output, level)
    output << ("  " * level)
  end

end
