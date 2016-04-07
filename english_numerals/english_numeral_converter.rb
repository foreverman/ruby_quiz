class EnglishNumeralConverter

  def decompose_with_thousands(arabic_number)
    components = []
    quo, mod = arabic_number.divmod 1000
    components <<  mod
    while quo >= 1000
      quo, mod = quo.divmod 1000
      components <<  mod
    end
    components << quo
    components
  end
  
  def to_english_numeral(arabic_number)
    scales = %w(thousand million billion trillion)
    components_divided_by_thousands = decompose_with_thousands(arabic_number)
    english_numerals = []
    components_divided_by_thousands.each_with_index do |component, index|
      next if component == 0
      english_numeral = less_than_one_thousand(component)
      unless index == 0
        english_numeral << (" " + scales[index - 1])
      end
      english_numerals.unshift(english_numeral)
    end
    last = english_numerals.pop
    result = english_numerals.join(" ")
    if !result.empty? && last && !last.include?("hundred")
      result << " and"
    end
    result << " " unless result.empty?
    result << last if last

    result.empty? ? "zero" : result
  end

  def less_than_one_thousand(arabic_number)
    result = ""
    quo, mod = arabic_number.divmod(100)
    if quo != 0
      result << "#{less_than_one_hundred(quo)} hundred"
    end
    if mod != 0 
      unless result.empty?
        result << " and "
      end
      result << less_than_one_hundred(mod)
    end
    result.empty? ? "zero" : result
  end

  def less_than_one_hundred(arabic_number)
    mappings = {}
    simple_english_numerals = %w(
      zero one two three four five six seven eight nine ten 
      eleven twelve thirteen fourteen fifteen sixteen seventeen
      eighteen nineteen
    )

    simple_english_numerals.each_with_index do |english_numeral, index|
      mappings[index] = english_numeral
    end
    
    mappings.merge!({ 
      20 => 'twenty', 30 => 'thirty', 40 => 'forty', 
      50 => 'fifty', 60 => 'sixty', 70 => 'seventy', 80 => 'eighty',
      90 => 'ninety' 
    })

    result = mappings[arabic_number]
    unless result 
      quotient, modulus = arabic_number.divmod(10)
      if quotient != 0
        result = mappings[quotient * 10]
      end

      if modulus != 0
        if result
          result += "-"
        end
        result += mappings[modulus]
      end
    end
    result
  end
end
