require 'pathname'

class WordSearch
  
  WS_CONFIG = YAML.load_file("config/word_search.yaml")
  DICTIONARY_PATH = WS_CONFIG["dictionary_path"]
  TOKEN_SIZE = WS_CONFIG["token_size"]
  
  # Initialize a WordSearch object. Requires a valid file path be passed in. Defaults to dictionary_path
  # in config/word_search.yaml.
  def initialize(fp = DICTIONARY_PATH)
    if fp.nil?
      raise ArgumentError.new("WordSearch requires a path to a dictionary file to load. Please add the path to that file in config/word_search.yaml.")
    else
      @dictionary_file = Pathname.new(fp)
      if !@dictionary_file.exist?
        @dictionary_file = nil
        raise ArgumentError.new("The file '#{fp}' does not exist. Please check the file path for the dictionary file. Hint: This is normally set in config/word_search.yaml.")
      end    
    end    
  end
  
  private
  
  # This method splits a String into tokens of the size specified. Defaults to a token size of 1. 
  # Takes a String and optional Integer or Fixnum. Returns an Array.
  def tokenizer(str, token_size = 1)
    # Treat token_size of 0 as if it was a 1.
    if token_size == 0
      token_size = 1
    end
    
    if token_size == 1
      token_array = str.split("")
    else
      token_array = []
      ul = str.length - 1
      ll = 0
      ts = token_size - 1
      while ts <= ul
        token_array << str[ll..ts]
        ll += 1
        ts += 1
      end 
    end
    
    return token_array
  end  
end
