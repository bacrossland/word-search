require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'yaml'
require File.dirname(__FILE__) + '/lib/word_search'
require 'benchmark'

desc 'Default: run unit tests.'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'Generate documentation for word-search.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Word-Search'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :word_search do

  desc 'Generate the questions and answers files.'
  task :q_and_a do
    a = WordSearch.new
    puts "Generation started..."
    Benchmark.bm do |bm|
      bm.report("sec:") do
        a.q_and_a
      end
    end    
    puts "Generation complete."
  end
  
  desc 'Benchmark Word-Search: includes file generation.'
  task :qa_benchmark do
    a = WordSearch.new
    puts "Benchmark started..."
    Benchmark.bmbm do |bm|
      bm.report("sec:") do
        a.q_and_a
      end
    end    
    puts "Benchmark complete."
  end
end