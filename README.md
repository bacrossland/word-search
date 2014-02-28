Word-Search
===========

Word-Search is a Ruby class for tokenizing and indexing a dictionary file. The class can be configured
to create different size tokens, clean tokens of numbers, non-words, or both, and customize file locations/names.

## Ruby Versions

Word-Search was written and tested using Ruby 1.9.3.

## Installation

To install simply clone this reposity or download the zip file and unpack.

	git clone git@github.com:bacrossland/word-search.git

## Running and Testing

Rake is used to run this class against it's the default dictionary file. With the default configuraion, it will
generate two files; questions.txt and answers.txt. It will place those files in the tmp directory. If you don't
want them to go there you can change the location in the config/word_search.yaml.

	rake word_search:q_and_a

To run the test suite use the following rake command:
	
	rake test

There are other commands availible through rake. To see them run:

	rake -T

## Configuration

Word-Search can be configured by changing the parameters in the config/word_search.yaml file. Configuration
options are as follows:

   dictionary_path = path to the dictionary file.
   token_size = size of the token to create. Must be an Integer greater than zero (0).
   char_clean = type of characters to remove from the tokens. If left blank none will be removed.
                Spaces will always be removed. Options: numbers, non-word, both.
   output_dir = the directory to output the questions.txt and answers.txt files. Default is tmp.
   token_filename = name of the token output file. Default is questions.txt.
   word_filename = name of the values output file. Default is answers.txt.	

## Why was Word-Search created?

Word-Search was created to answer the following challenge:

Given a list of words, generate two output files, 'questions' and 'answers'. 'questions' should contain every
sequence of four letters that appears in exactly one word of the dictionary, one sequence per line. 
'answers' should contain the corresponding words that contain the sequences, in the same order,
again one per line.

An example:

Say this is your dictionary:
	arrows
	carrots
	give
	me

'questions' would contain:
	carr
	give
	rots
	rows
	rrot
	rrow

and 'answers' would have:
	carrots
	give
	carrots
	arrows
	carrots
	arrows

'arro' wouldn't show up in 'questions', because it appears in two words

## Questions
Q: What about numbers and apostrophes?  
A: Numbers and apostrophes (non-word characters) are treated as string characters by Word-Search. They can be 
removed or left in when building the tokens that make up the questions.txt file. Just configure the option you 
want in config/word_search.yaml. The unaltered word will always be returned in answers.txt.

For example: 

The word "ain't" when having non-word characters removed will result in a question of "aint" and an answer of "ain't".

The word "10th" when having numbers removed, and a token size of 2, will result in a question of "th" and an answer of "10th".
