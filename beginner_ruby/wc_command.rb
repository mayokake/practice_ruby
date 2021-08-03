# frozen_string_literal: true

require 'optparse'

parameter = ARGV.getopts('l')
l_option = parameter['l']
files = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
files_from_argument = ARGV.select { |string| files.include?(string) }

# word count command assignment
class WordCount
  def self.full_information(array)
    word_count = WordCount.new(array)
    word_count.full_information
  end

  def self.lines_only(array)
    line_in_word_count = WordCount.new(array)
    line_in_word_count.lines_only
  end

  def initialize(array)
    @array = array
    @array_file_read = @array.map { |string| File.read(string) }
  end

  def full_information
    @array_file_read.map.with_index do |string, i|
      merge_information(string)
      puts " #{file_name(@array[i])}"
    end
    total
  end

  def lines_only
    @array_file_read.map.with_index do |string, i|
      only_lines(string)
      puts " #{file_name(@array[i])}"
    end
    total_lines_only
  end

  private

  def merge_information(string)
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

  def file_name(string)
    string
  end

  def lines_number(string)
    string.count("\n")
  end

  def words(string)
    string.split(/\s/).reject(&:empty?).size
  end

  def bytes(string)
    string.bytesize
  end

  def lines_number_sum
    numbers = @array_file_read.map { |string| lines_number(string) }
    numbers.sum
  end

  def words_sum
    number = @array_file_read.map { |string| words(string) }
    number.sum
  end

  def bytes_sum
    num = @array_file_read.map { |string| bytes(string) }
    num.sum
  end

  def only_lines(input)
    lines = lines_number(input)
    print lines.to_s.rjust(8)
  end
end

# word count from input
class WordCountFromInput
  def self.full_from_input(input)
    word_count_from_input = WordCountFromInput.new(input)
    word_count_from_input.full_from_input
  end

  def self.line(input)
    word_count_from_input2 = WordCountFromInput.new(input)
    puts word_count_from_input2.line.to_s.rjust(8)
  end

  def full_from_input
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

if files_from_argument.empty? && l_option == false
  input = $stdin.read
  WordCountFromInput.full_from_input(input)
elsif files_from_argument.empty? && l_option == true
  input = $stdin.read
  WordCountFromInput.line(input)
elsif files_from_argument.empty? == false && l_option == false
  WordCount.full_information(files_from_argument)
else
  WordCount.lines_only(files_from_argument)
end
