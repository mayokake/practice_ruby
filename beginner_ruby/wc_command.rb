# frozen_string_literal: true

require 'optparse'

parameter = ARGV.getopts('l')
l_option = parameter['l']
array_files_only = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
array_from_argument = ARGV.select { |string| array_files_only.include?(string)}
array_file_read = array_from_argument.map { |string| File.read(string)}

class WordCount
  def self.all(array)
    word_count = WordCount.new(array)
    word_count.all
  end

  def self.total_lines_only(array)
    word_count2 = WordCount.new(array)
    word_count2.total_lines_only
  end

  def self.lines_only(array)
    word_count3 = WordCount.new(array)
    word_count3.lines_only
  end

  def initialize(array)
    @array = array
    @array_convert = @array.map { |string| File.read(string)}
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
    lines = lines_number(input) # 行数
    print lines.to_s.rjust(8)
  end

  def words(string)
    string.split(/\s/).reject(&:empty?).size
  end
  
  def words_sum
    number = @array_convert.map {|string| words(string)}
    number.sum
  end

  def bytes(string)
    string.bytesize
  end
  
  def bytes_sum
    num = @array_convert.map{|string| bytes(string)}
    num.sum
  end

  def merge_data(string)
    lines = lines_number(string)
    words = words(string)
    bytes = bytes(string)
    print lines.to_s.rjust(8)
    print words.to_s.rjust(8)
    print bytes.to_s.rjust(8)
  end

  def total
    lines = lines_number_sum
    words = words_sum
    bytes = bytes_sum  
    print lines.to_s.rjust(8)
    print words.to_s.rjust(8)
    print bytes.to_s.rjust(8)
    puts ' total'
  end

  def total_lines_only
    lines = lines_number_sum
    print lines.to_s.rjust(8)
    puts ' total'
  end
end

l_option ? WordCount.lines_only(array_from_argument) : WordCount.all(array_from_argument)
