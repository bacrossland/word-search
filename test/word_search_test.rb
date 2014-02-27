require 'test/unit'
require 'pathname'
require 'yaml'
require 'word_search'

# Make private WordSearch methods public for testing.
class WordSearch
    public *self.private_instance_methods(false)
end

class WordSearchTest < Test::Unit::TestCase
  WS_CONFIG = YAML.load_file("config/word_search.yaml")
  DICTIONARY_PATH = WS_CONFIG["dictionary_path"]
  TOKEN_SIZE = WS_CONFIG["token_size"]
  
  # This test checks to see if dictionary file is present. 
  def test_config
    dictionary_path = Pathname.new(DICTIONARY_PATH)
    assert(dictionary_path.exist?, "The dictionary_path file '#{DICTIONARY_PATH}' does not exist.")
    assert_instance_of(Fixnum, TOKEN_SIZE) unless TOKEN_SIZE.nil?
  end
  
  # A test of the WordSearch class initialize method.
  def test_word_search_init
    assert_raise(ArgumentError){WordSearch.new('sdsdf.txt')}
    assert_nothing_raised{WordSearch.new}    
  end
  
  # A test of the tokenizer WordSearch private instance method.
  def test_tokenizer
    a = WordSearch.new.tokenizer("guild")
    b = WordSearch.new.tokenizer("guild", 2)
    c = WordSearch.new.tokenizer("guild", 3)
    d = WordSearch.new.tokenizer("guild", 4)
    e = WordSearch.new.tokenizer("guild", 5)
    f = WordSearch.new.tokenizer("guild", 0)
    g = WordSearch.new.tokenizer("guild", 6)
    assert_instance_of(Array, a)
    assert_equal(["g","u","i","l","d"], a)
    assert_equal(["gu","ui","il","ld"], b)
    assert_equal(["gui","uil","ild"], c)
    assert_equal(["guil","uild"], d)
    assert_equal(["guild"], e)
    assert_equal(["g","u","i","l","d"], f)
    assert_equal([], g)
  end  
  
  # A test of the indexer WordSearch private instance method.
  def test_indexer
    a = WordSearch.new.indexer("guild", ["g","u","i","l","d"])
    assert_instance_of(Hash, a)
    assert_equal({"g"=>"guild","u"=>"guild","i"=>"guild","l"=>"guild","d"=>"guild"}, a)
  end
  
  # A test of the cleaner WordSearch private instance method.
  def test_cleaner
    a = WordSearch.new.cleaner("gui5ld6ed", "numbers")
    b = WordSearch.new.cleaner("g#uild!e---d", "non-word")
    c = WordSearch.new.cleaner("g3#1ui4ld!e-5--d8", "both")
    d = WordSearch.new.cleaner("    mat rules   ")
    assert_instance_of(String, a)
    assert_equal("guilded", a)
    assert_equal("guilded", b)
    assert_equal("guilded", c)
    assert_equal("matrules", d)
  end    
end


