require 'test/unit'
require 'pathname'
require 'yaml'
require 'word_search'

class WordSearchTest < Test::Unit::TestCase
  WS_CONFIG = YAML.load_file("config/word_search.yaml")
  DICTIONARY_PATH = WS_CONFIG["dictionary_path"]
  
  # This test checks to see if dictionary file is present. 
  def test_config
    dictionary_path = Pathname.new(DICTIONARY_PATH)
    assert(dictionary_path.exist?, "The dictionary_path file '#{DICTIONARY_PATH}' does not exist.")
  end
  
  # A test of the WordSearch class initialize method.
  def test_word_search_init
    assert_raise(ArgumentError){WordSearch.new}
    assert_raise(ArgumentError){WordSearch.new('sdsdf.txt')}
    assert_nothing_raised{WordSearch.new(DICTIONARY_PATH)}    
  end
end


