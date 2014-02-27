require 'pathname'

class WordSearch
  
  # Initialize a WordSearch object. Requires a valid file path be passed in.
  def initialize(fp = nil)
    if fp.nil?
      raise ArgumentError.new("WordSearch requires a path to a dictionary file to load.")
    else
      @dictionary_file = Pathname.new(fp)
      if !@dictionary_file.exist?
        @dictionary_file = nil
        raise ArgumentError.new("The file '#{fp}' does not exist.")
      end    
    end    
  end
    
end
