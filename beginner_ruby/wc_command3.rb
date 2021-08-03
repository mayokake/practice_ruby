# frozen_string_literal: true

require 'optparse'

# Lオプションの取得
parameter = ARGV.getopts('l')

# 変数定義
l_option = parameter['l']

# 名称変更必須 
array_files_only = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }

# 名称変更必須
array_from_argument = ARGV.select { |string| array_files_only.include?(string) }
# p array_from_argument

# array_convert = array_from_argument.map { |string| File.read(string) }
# p array_convert


# array_convert.map do |file_read|
#   lines = file_read.string.count("\n")
#   words = file_read.string.split(/\s/).reject(&:empty?).size
#   byes = file_read.string.bytesize
# end

# def arrange(array)
#   array_converted = array.map { |string| File.read(string) }
#   array_converted.map do |file|
#     lines = file.count("\n")
#     words = file.split(/\s/).reject(&:empty?).size
#     byes = file.bytesize
#     puts "#{lines} #{words} #{byes}"
#   end
# end

input = $stdin.read

def tantai(input)
  lines = input.count("\n")
  words = input.split(/\s/).reject(&:empty?).size
  bytes = input.bytesize
  puts "#{lines.to_s.rjust(8)}#{words.to_s.rjust(8)}#{bytes.to_s.rjust(8)}"
end

# tantai(input)


def lines(str)
  str.count("\n")
end

# 単語数を取得
def load_words(str)
  str.split(/\s/).reject(&:empty?).size
end

# バイト数を取得
def load_bytes(str)
  str.bytesize
end

def all_data(input)
  lines = load_lines(input) # 行数
  words = load_words(input) # 単語数
  bytes = load_bytes(input) # バイト数
  
  print lines.to_s.rjust(8)
  print words.to_s.rjust(8)
  print bytes.to_s.rjust(8)
  puts
end

all_data(input)





def arrange(array)
  array.map do |string|
    file = File.read(string)
    # tantai(file)
    lines = file.count("\n")
    words = file.split(/\s/).reject(&:empty?).size
    bytes = file.bytesize
    puts "#{lines.to_s.rjust(8)}#{words.to_s.rjust(8)}#{bytes.to_s.rjust(8)} #{string}"
    a = []
    a << lines
    a << words
    a << bytes
  end
end



test_a1 =  arrange(array_from_argument)
p test_a1

test_a2 = test_a1.transpose
p test_a2

# test_a3 = test_a2.map.with_index do |array, index|
#   if index == test_a2.size - 1
#      puts "#{array.sum.to_s.rjust(8)}" +  " total"
#   else 
#     print array.sum.to_s.rjust(8)
#   end
# end

def totals(array)
  array.map.with_index do |string, index|
    if index == array.size - 1
       puts "#{string.sum.to_s.rjust(8)}" +  " total"
    else 
      print string.sum.to_s.rjust(8)
    end
  end
end

totals(test_a2)

# p test_a3




# p arrange(array_from_argument).transpose


# word count command assignment
# class WordCount
#   def self.all(array)
#     word_count = WordCount.new(array)
#     word_count.all
#   end

#   def self.lines_only(array)
#     word_count3 = WordCount.new(array)
#     word_count3.lines_only
#   end

#   def initialize(array)
#     @array = array
#     @array_convert = @array.map { |string| File.read(string) }
#   end

#   def all
#     @array_convert.map.with_index do |string, i|
#       merge_data(string)
#       puts " #{file_name(@array[i])}"
#     end
#     total
#   end

#   def lines_only
#     @array_convert.map.with_index do |string, i|
#       only_lines(string)
#       puts " #{file_name(@array[i])}"
#     end
#     total_lines_only
#   end

#   private

#   def merge_data(string)
#     lines = lines_number(string).to_s.rjust(8)
#     words = words(string).to_s.rjust(8)
#     bytes = bytes(string).to_s.rjust(8)
#     print "#{lines}#{words}#{bytes}"
#   end

#   def total
#     lines = lines_number_sum.to_s.rjust(8)
#     words = words_sum.to_s.rjust(8)
#     bytes = bytes_sum.to_s.rjust(8)
#     puts "#{lines}#{words}#{bytes} total"
#   end

#   def file_name(string)
#     string
#   end

#   def lines_number(string)
#     string.count("\n")
#   end

#   def lines_number_sum
#     numbers = @array_convert.map { |string| lines_number(string) }
#     numbers.sum
#   end

#   def only_lines(input)
#     lines = lines_number(input)
#     print lines.to_s.rjust(8)
#   end

#   def words(string)
#     string.split(/\s/).reject(&:empty?).size
#   end

#   def words_sum
#     number = @array_convert.map { |string| words(string) }
#     number.sum
#   end

#   def bytes(string)
#     string.bytesize
#   end

#   def bytes_sum
#     num = @array_convert.map { |string| bytes(string) }
#     num.sum
#   end

#   def total_lines_only
#     lines = lines_number_sum.to_s.rjust(8)
#     puts "#{lines} total"
#   end
# end

# # word count from input
# class WordCountFromInput
#   def self.all_from_input(input)
#     word_count_from_input = WordCountFromInput.new(input)
#     word_count_from_input.all_from_input
#   end

#   def self.line(input)
#     word_count_from_input2 = WordCountFromInput.new(input)
#     puts word_count_from_input2.line.to_s.rjust(8)
#   end

#   def all_from_input
#     lines = line.to_s.rjust(8)
#     words = word.to_s.rjust(8)
#     bytes = byte.to_s.rjust(8)
#     puts "#{lines}#{words}#{bytes}"
#   end

#   def initialize(input)
#     @input = input
#   end

#   def line
#     @input.count("\n")
#   end

#   private

#   def word
#     @input.split(/\s/).reject(&:empty?).size
#   end

#   def byte
#     @input.bytesize
#   end
# end

# if array_from_argument.empty? && l_option == false
#   input = $stdin.read
#   WordCountFromInput.all_from_input(input)
# elsif array_from_argument.empty? && l_option == true
#   input = $stdin.read
#   WordCountFromInput.line(input)
# elsif array_from_argument.empty? == false && l_option == true
#   WordCount.lines_only(array_from_argument)
# else
#   WordCount.all(array_from_argument)
# end
