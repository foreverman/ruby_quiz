require "minitest/autorun"
require_relative "./gedcom_parser"

class TestGedcomParser < Minitest::Test
  def test_parse_simple_format_successfully
    input = File.read('sample_input.ged')
    parser = GedcomParser.new
    output = parser.parse(input)
    puts output
    expected_output = File.read('expected_sample_output.xml') 
    assert_equal expected_output, output
  end
end
