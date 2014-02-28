require 'pathname'

# == WordSearch
#
# This class tokenizes and indexes a dictionary file.
class WordSearch
  
  # WordSearch config file.
  WS_CONFIG = YAML.load_file("config/word_search.yaml")
  # Path to dictionary file.
  DICTIONARY_PATH = WS_CONFIG["dictionary_path"]
  # Size of tokens to create.
  TOKEN_SIZE = WS_CONFIG["token_size"]
  # Types of characters to clean
  CHAR_CLEAN = WS_CONFIG["char_clean"]
  # Set the default output directory to tmp if not defined in config/word_search.yaml
  WS_CONFIG["output_dir"] ||= "tmp"
  # Output directory for token and word file creation.
  OUTPUT_DIR = WS_CONFIG["output_dir"]
  # Set the default token filename to questions.txt if not defined in config/word_search.yaml
  WS_CONFIG["token_filename"] ||= "questions.txt"
  # Token filename.
  TOKEN_FILENAME = WS_CONFIG["token_filename"]
  # Set the default word filename to answers.txt if not defined in config/word_search.yaml
  WS_CONFIG["word_filename"] ||= "answers.txt"
  # Word filename.
  WORD_FILENAME = WS_CONFIG["word_filename"]
  
  # Initialize a WordSearch object. Requires a valid file path to be passed in. Defaults to dictionary_path
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
  
  # This method creates the token index. It takes optional Fixnum and String arguements to override default token_size and char_clean repsectively. 
  # Returns a Hash. Defaults are set in config/word_search.yaml.
  def create_index(token_size = TOKEN_SIZE, char_clean = CHAR_CLEAN)
    token_index = {}
    @dictionary_file.each_line do |line|
      org_value = line.gsub(/\s/,"")
      unless org_value.empty?
        clean_str = cleaner(line,char_clean)
        token_arr = tokenizer(clean_str, token_size)
        line_index = indexer(org_value, token_arr)
        token_index = token_index.merge(line_index){|key,oldval,newval| oldval << newval[0] }
      end
    end
    # Sort the resulting Hash alphabetically by key. Return the newly sorted Hash.
    arr_tmp = token_index.sort_by{|key, value| key}.flatten(1)
    token_index = Hash[*arr_tmp]
    return token_index
  end
  
  # This method generates the question and answer files from the Hash returned by create_index. The Hash has all key/value pairs removed
  # where the value Array has a size greater than 1. The remaining key/value pairs are output into two files; keys to questions.txt and 
  # values to answers.txt with each line of the file holding a single key or value respectively. The keys will be unique while the values 
  # might not be. The method takes optional Fixnum and String arguements to override default token_size and char_clean repsectively. 
  # Defaults are set in config/word_search.yaml.
  def q_and_a(token_size = TOKEN_SIZE, char_clean = CHAR_CLEAN)
    token_index = create_index(token_size,char_clean)
    unique_index = token_index.delete_if{|key, value| value.size > 1}
    output_dir = Pathname.new(OUTPUT_DIR)
    output_dir.mkpath if !output_dir.exist?
    token_file = File.open(File.join(OUTPUT_DIR, TOKEN_FILENAME), "w")
    word_file = File.open(File.join(OUTPUT_DIR, WORD_FILENAME), "w")
    unique_index.each do |key, value|
      token_file.puts key
      word_file.puts value
    end  
    token_file.close
    word_file.close
  end
  
  private
  
  # This method splits a String into tokens of the size specified. Defaults to a token size of 1. 
  # Takes a String and optional Integer or Fixnum. Returns an Array.
  def tokenizer(str, token_size = 1)
    # Treat token_size of 0 as if it was a 1.
    if token_size <= 0
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
  
  # This method takes a String and an Array of tokens to convert them into a reverse index Hash. 
  # The tokens are the keys and the String is the value in Array form. Takes a String and Array. Returns Hash.
  def indexer(str, arr)
    token_index = Hash[arr.map {|x| [x, [str]]}]
    return token_index
  end
  
  # This method takes a String and removes the requested character set from it. Defaults to char_clean
  # in config/word_search.yaml. Takes a String and an optional String. Returns String.
  def cleaner(str,char_to_clean = CHAR_CLEAN)
    case char_to_clean
      when "numbers"
        clean_str = str.gsub(/\d/,"").downcase
      when "non-word"
        clean_str = str.gsub(/\W/,"").downcase
      when "both"
        clean_str = str.gsub(/\d/,"").gsub(/\W/,"").downcase
      else
        # Remove nothing but still downcase.
        clean_str = str.downcase
    end
    # Remove any spaceing characters.
    clean_str.gsub!(/\s/,"")
    return clean_str                
  end   
end
