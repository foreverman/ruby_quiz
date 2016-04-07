require "minitest/autorun"
require_relative "./english_numeral_converter"

class TestEnglishNumeralConversion < Minitest::Test

  def setup
    @converter = EnglishNumeralConverter.new
  end
  def test_convert_simple_english_numerals

    simple_english_numerals = %w(
      zero one two three four five six seven eight nine ten 
      eleven twelve thirteen fourteen fifteen sixteen seventeen
      eighteen nineteen
    )

    simple_english_numerals.each_with_index do |english_numeral, index|
      assert_equal english_numeral, @converter.to_english_numeral(index)
    end

    { 
      20 => 'twenty', 30 => 'thirty', 40 => 'forty', 
      50 => 'fifty', 60 => 'sixty', 70 => 'seventy', 80 => 'eighty',
      90 => 'ninety' 
    }.each do |arabic_number, english_numeral|
      assert_equal english_numeral, @converter.to_english_numeral(arabic_number)
    end
  end

  def test_simple_composite_numbers
    {
     21 => "twenty-one", 22 => "twenty-two", 
     29 => "twenty-nine", 33 => "thirty-three", 99 => "ninety-nine"
    }.each do |arabic_number, english_numeral| 
      assert_equal english_numeral, @converter.to_english_numeral(arabic_number)
    end
  end

  def test_hundreds
    {
      100 => "one hundred", 101 => "one hundred and one", 111 => "one hundred and eleven", 
      121 => "one hundred and twenty-one", 999 => "nine hundred and ninety-nine"
    }.each do |arabic_number, english_numeral| 
      assert_equal english_numeral, @converter.to_english_numeral(arabic_number)
    end
  end

  def test_thousands
    {
      2001 => "two thousand and one", 1999 => "one thousand nine hundred and ninety-nine",
    }.each do |arabic_number, english_numeral| 
      assert_equal english_numeral, @converter.to_english_numeral(arabic_number)
    end
  end
end
