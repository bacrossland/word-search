word-search
===========

Given a list of words (I've attached a list), generate two output
files, 'questions' and 'answers'. 'questions' should contain every
sequence of four letters that appears in exactly one word of the
dictionary, one sequence per line. 'answers' should contain the
corresponding words that contain the sequences, in the same order,
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



My Questions:
What about numbers and apostrophes?  I could try to skip over them and include 'aint' => 'ain't'
But right now I just skip any fragment that contains an apostrophe.  And same goes for integers.