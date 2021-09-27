# frozen_string_literal: true

require 'optparse'

# Lオプションの取得
parameter = ARGV.getopts('l')

# 変数定義
l_option = parameter['l']

# ディレクトリにあるファイルのみを対象とする
files_only = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }

# 引数から指定されたファイル、かつディレクトリにある
files_in_the_argument = ARGV.select { |string| files_only.include?(string) }

# 第2変数とする
strings_array = files_in_the_argument.map { |string| File.read(string) }



# word count command assignment
class WordCount
  def self.all_information(array, array2)
    word_count = WordCount.new(array, array2)
    word_count.all_information
  end

  def self.lines_only(array, array2)
    word_count3 = WordCount.new(array, array2)
    word_count3.lines_only
  end

  def initialize(array, array2)
    @array = array
    @array2 = array2
  end

  def all_information
    @array2.map.with_index do |string, i|
      merge_data(string)
      puts " #{@array[i]}"
    end
    total
  end

  def lines_only
    @array2.map.with_index do |string, i|
      only_lines(string)
      puts " #{@array[i]}"
    end
    total_lines_only
  end

  private

  def merge_data(string)
    line_num = string.count("\n").to_s.rjust(8)
    word_num = string.split(/\s/).reject(&:empty?).size.to_s.rjust(8)
    byte_num = string.bytesize.to_s.rjust(8)
    print "#{line_num}#{word_num}#{byte_num}"
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

  def total
    lines = lines_number_sum.to_s.rjust(8)
    words = words_sum.to_s.rjust(8)
    bytes = bytes_sum.to_s.rjust(8)
    puts "#{lines}#{words}#{bytes} total"
  end

  def lines_number_sum
    numbers = @array2.map { |string| string.count("\n") }
    numbers.sum
  end

  def words_sum
    number = @array2.map { |string| string.split(/\s/).reject(&:empty?).size }
    number.sum
  end
    
  def bytes_sum
    num = @array2.map { |string| string.bytesize }
    num.sum
  end

  def only_lines(input)
    lines = lines_number(input)
    print lines.to_s.rjust(8)
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

if files_in_the_argument.empty? && l_option == false
  input = $stdin.read
  WordCountFromInput.all_from_input(input)
elsif files_in_the_argument.empty? && l_option == true
  input = $stdin.read
  WordCountFromInput.line(input)
elsif files_in_the_argument.empty? == false && l_option == true
  WordCount.lines_only(files_in_the_argument, strings_array)
else
  WordCount.all_information(files_in_the_argument, strings_array)
end
