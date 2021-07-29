# frozen_string_literal: true

require 'optparse'

parameter = ARGV.getopts('l')
l_option = parameter['l']
array_files_only = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
array_from_argument = ARGV.select { |string| array_files_only.include?(string) }

# word count command assignment
class WordCount
  def self.all(array)
    word_count = WordCount.new(array)
    word_count.all
  end

  def self.lines_only(array)
    word_count3 = WordCount.new(array)
    word_count3.lines_only
  end

  def initialize(array)
    @array = array
    @array_convert = @array.map { |string| File.read(string) }
  end

  def all
    @array_convert.map.with_index do |string, i|
      merge_data(string)
      puts " #{file_name(@array[i])}"
    end
    total
  end

  def lines_only
    @array_convert.map.with_index do |string, i|
      only_lines(string)
      puts " #{file_name(@array[i])}"
    end
    total_lines_only
  end

  private

  def file_name(string)
    string
  end

  def lines_number(string)
    string.count("\n")
  end

  def lines_number_sum
    numbers = @array_convert.map { |string| lines_number(string) }
    numbers.sum
  end

  def only_lines(input)
    lines = lines_number(input)
    print lines.to_s.rjust(8)
  end

  def words(string)
    string.split(/\s/).reject(&:empty?).size
  end

  def words_sum
    number = @array_convert.map { |string| words(string) }
    number.sum
  end

  def bytes(string)
    string.bytesize
  end

  def bytes_sum
    num = @array_convert.map { |string| bytes(string) }
    num.sum
  end

  def merge_data(string)
    lines = lines_number(string).to_s.rjust(8)
    words = words(string).to_s.rjust(8)
    bytes = bytes(string).to_s.rjust(8)
    print "#{lines}#{words}#{bytes}"
  end

  def total
    lines = lines_number_sum.to_s.rjust(8)
    words = words_sum.to_s.rjust(8)
    bytes = bytes_sum.to_s.rjust(8)
    puts "#{lines}#{words}#{bytes} total"
  end

  def total_lines_only
    lines = lines_number_sum.to_s.rjust(8)
    puts "#{lines} total"
  end
end

# word count from input
class WordCountFromInput
  def self.all_from_input(input)
    word_count_from_input = WordCountFromInput.new(input)
    word_count_from_input.all_from_input
  end

  def self.line(input)
    word_count_from_input2 = WordCountFromInput.new(input)
    puts word_count_from_input2.line.to_s.rjust(8)
  end

  def all_from_input
    lines = line.to_s.rjust(8)
    words = word.to_s.rjust(8)
    bytes = byte.to_s.rjust(8)
    puts "#{lines}#{words}#{bytes}"
  end

  def initialize(input)
    @input = input
  end

  def line
    @input.count("\n")
  end

  private

  def word
    @input.split(/\s/).reject(&:empty?).size
  end

  def byte
    @input.bytesize
  end
end

if array_from_argument.empty? && l_option == false
  input = $stdin.read
  WordCountFromInput.all_from_input(input)
elsif array_from_argument.empty? && l_option == true
  input = $stdin.read
  WordCountFromInput.line(input)
elsif array_from_argument.empty? == false && l_option == true
  WordCount.lines_only(array_from_argument)
else
  WordCount.all(array_from_argument)
end
