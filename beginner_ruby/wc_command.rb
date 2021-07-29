# frozen_string_literal: true

require 'optparse'

parameter = ARGV.getopts('l')
array_files_only = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
array_from_argument = ARGV.select { |string| array_files_only.include?(string)}
array_file_read = array_from_argument.map { |string| File.read(string)}

# p array_file_read

class WordCount
  def initialize(array)
    @array = array
  end

  

  def file_name(str)
    str
  end

  def lines_number(str)
    str.count("\n")
  end

  def lines_number_sum(array)
    numbers = array.map{|string| lines_number(string)}
    numbers.sum
  end

  def words(str)
    str.split(/\s/).reject(&:empty?).size
  end
  
  def words_sum(array)
    num = array.map{|string| words(string)}
    num.sum
  end

  def bytes(str)
    str.bytesize
  end
  
  def bytes_sum(array)
    num = array.map{|string| bytes(string)}
    num.sum
  end

  def merge_data(input)
    lines = lines_number(input)
    words = words(input)
    bytes = bytes(input)
    print lines.to_s.rjust(8)
    print words.to_s.rjust(8)
    print bytes.to_s.rjust(8)
    # puts
  end





  



end


def file_name(str)
  str
end

# 行数を取得
def lines_number(str)
  str.count("\n")
end

def lines_number_sum(array)
  num = array.map{|string| lines_number(string)}
  num.sum
end

# 単語数を取得
def words(str)
  str.split(/\s/).reject(&:empty?).size
end

def words_sum(array)
  num = array.map{|string| words(string)}
  num.sum
end

# バイト数を取得
def bytes(str)
  str.bytesize
end

def bytes_sum(array)
  num = array.map{|string| bytes(string)}
  num.sum
end

def total(input)
  lines = lines_number_sum(input) # 行数
  words = words_sum(input) # 単語数
  bytes = bytes_sum(input) # バイト数

  print lines.to_s.rjust(8)
  print words.to_s.rjust(8)
  print bytes.to_s.rjust(8)
  puts ' total'
end

def merge_data(input)
  lines = lines_number(input) # 行数
  words = words(input) # 単語数
  bytes = bytes(input) # バイト数

  print lines.to_s.rjust(8)
  print words.to_s.rjust(8)
  print bytes.to_s.rjust(8)
  # puts
end

def only_lines(input)
  lines = lines_number(input) # 行数
  print lines.to_s.rjust(8)
end

def total_lines_only(input)
  lines = lines_number_sum(input) # 行数
  print lines.to_s.rjust(8)
  puts ' total'
end


def all(array)
  array.map do |string|
    one_string = File.read(string)
    merge_data(one_string)
    puts " #{file_name(string)}"
  end
end

def lines_only(array)
  array.map do |string|
    one_string = File.read(string)
    only_lines(one_string)
    puts " #{file_name(string)}"
  end
end

lines_only(array_from_argument)
total_lines_only(array_file_read)

puts ""
puts ""

all(array_from_argument)
total(array_file_read)
