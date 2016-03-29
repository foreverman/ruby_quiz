class GedcomParser
  def parse(input)
    endtags_stack = []
    output = ""
    output += "<gedcom>"
    output += "\n"
    input.each_line do |line|
      level, id_or_tag, data = *line.split(/\s+/, 3)
      id_or_tag = id_or_tag.strip
      level = level.to_i

      #output end tag
      while(level <= (endtags_stack.size - 1))
        output += "</#{endtags_stack.pop}>"
        output += "\n"
      end

      output += "  " * (level + 1)
      if id_or_tag =~ /@.+@/ 
        id = id_or_tag
        tag = data.downcase
        output += "<#{tag} id=\"#{id}\">"
        output += "\n"
      else
        tag = id_or_tag.downcase
        output += "<#{tag}>"
        output += "\n"
        output += "  " * (level + 2)
        output += data
        output += "\n"
      end
      endtags_stack << tag
    end
    
    #end tags that haven't got chances to do so
    while(endtags_stack.any?)
      output += "</#{endtags_stack.pop}>"
      output += "\n"
    end
    output += "</gedcom>"
  end
end
