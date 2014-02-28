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
  CHAR_CLEAN = WS_CONFIG["char_clean"]
  WS_CONFIG["output_dir"] ||= "tmp"
  OUTPUT_DIR = WS_CONFIG["output_dir"]
  WS_CONFIG["token_filename"] ||= "questions.txt"
  TOKEN_FILENAME = WS_CONFIG["token_filename"]
  WS_CONFIG["word_filename"] ||= "answers.txt"
  WORD_FILENAME = WS_CONFIG["word_filename"]
  
  # This test checks to see if dictionary file is present. 
  def test_config
    dictionary_path = Pathname.new(DICTIONARY_PATH)
    assert(dictionary_path.exist?, "The dictionary_path file '#{DICTIONARY_PATH}' does not exist.")
    assert_instance_of(Fixnum, TOKEN_SIZE) unless TOKEN_SIZE.nil?
    assert_instance_of(String, CHAR_CLEAN) unless CHAR_CLEAN.nil?
    assert_instance_of(String, OUTPUT_DIR)
    assert_instance_of(String, TOKEN_FILENAME)
    assert_instance_of(String, WORD_FILENAME)
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
    h = WordSearch.new.tokenizer("guild", -3)
    assert_instance_of(Array, a)
    assert_equal(["g","u","i","l","d"], a)
    assert_equal(["gu","ui","il","ld"], b)
    assert_equal(["gui","uil","ild"], c)
    assert_equal(["guil","uild"], d)
    assert_equal(["guild"], e)
    assert_equal(["g","u","i","l","d"], f)
    assert_equal([], g)
    assert_equal(["g","u","i","l","d"], h)
  end  
  
  # A test of the indexer WordSearch private instance method.
  def test_indexer
    a = WordSearch.new.indexer("guild", ["g","u","i","l","d"])
    assert_instance_of(Hash, a)
    assert_equal({"g"=>["guild"],"u"=>["guild"],"i"=>["guild"],"l"=>["guild"],"d"=>["guild"]}, a)
  end
  
  # A test of the cleaner WordSearch private instance method.
  def test_cleaner
    a = WordSearch.new.cleaner("gui5ld6ed", "numbers")
    b = WordSearch.new.cleaner("g#uild!e---d", "non-word")
    c = WordSearch.new.cleaner("g3#1ui4ld!e-5--d8", "both")
    d = WordSearch.new.cleaner("    mat rules   ")
    e = WordSearch.new.cleaner("G3#1ui4lD!e-5--d8", "both")
    assert_instance_of(String, a)
    assert_equal("guilded", a)
    assert_equal("guilded", b)
    assert_equal("guilded", c)
    assert_equal("matrules", d)
    assert_equal("guilded", e)
  end 
  
  # A test of the create_index WordSearch public instance method.
  def test_create_index
    a = WordSearch.new("test/data/test_data.txt")
    a_hash = {"four" => ["Four"], "tour" => ["tour"], "sear" => ["search"], 
      "earc"=> ["search"], "arch"=>["search"], "than"=>["th!an#k"], 
      "hank"=>["th!an#k","hanks"], "leav"=>["leaves"], "eave"=>["leaves"], 
      "aves"=>["leaves"], "anks"=>["hanks"]}
    b_hash = {"four" => ["Four"], "tour" => ["tour"], "sear" => ["search"], 
      "earc"=> ["search"], "arch"=>["search"], "th!a"=>["th!an#k"],
      "h!an"=>["th!an#k"], "!an#"=>["th!an#k"], "an#k"=>["th!an#k"],
      "leav"=>["leaves"], "eave"=>["leaves"], 
      "aves"=>["leaves"], "hank"=>["hanks"], "anks"=>["hanks"]}
    c_hash = {"four" => ["Four"], "tour" => ["tour"], "sear" => ["search"], 
      "earc"=> ["search"], "arch"=>["search"], "than"=>["th!an#k"], 
      "hank"=>["th!an#k","hanks"], "501s"=> ["501st"], "01st"=>["501st"],
      "leav"=>["leaves"], "eave"=>["leaves"], 
      "aves"=>["leaves"], "anks"=>["hanks"]}
    d_hash = {"four" => ["Four"], "tour" => ["tour"], "sear" => ["search"], 
      "earc"=> ["search"], "arch"=>["search"], "th!a"=>["th!an#k"],
      "h!an"=>["th!an#k"], "!an#"=>["th!an#k"], "an#k"=>["th!an#k"],
      "501s"=> ["501st"], "01st"=>["501st"],
      "leav"=>["leaves"], "eave"=>["leaves"], 
      "aves"=>["leaves"], "hank"=>["hanks"], "anks"=>["hanks"]}      

    assert_instance_of(Hash, a.create_index(4,"both"))
    assert_equal(a_hash, a.create_index(4,"both"))
    assert_equal(b_hash, a.create_index(4,"numbers"))
    assert_equal(c_hash, a.create_index(4,"non-word"))
    assert_equal(d_hash, a.create_index(4,"junk words"))
  end
  
  # A test of the q_and_a WordSearch public instance method.
  def test_q_and_a
    a = WordSearch.new("test/data/test_dictionary.txt")
    assert_nothing_raised{a.q_and_a(4,"both")}
    #assert_equal("fdd",a.q_and_a(4,"both"))
  end       
end


