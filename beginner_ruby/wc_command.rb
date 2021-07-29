# frozen_string_literal: true

require 'optparse'

# p ARGV
parameter = ARGV.getopts('l')

array_get = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
condition_array = ARGV.select { |string| array_get.include?(string)}
p condition_array

string_array = condition_array.map { |string| File.read(string)}

def load_name(str)
  str
end

# p load_name(condition_array[0])

# 行数を取得
def load_lines(str)
  str.count("\n")
end

def load_lines_sum(array)
  num = array.map{|string| load_lines(string)}
  num.sum
end

# p load_lines_sum(string_array)

# 単語数を取得
def load_words(str)
  str.split(/\s/).reject(&:empty?).size
end

def load_words_sum(array)
  num = array.map{|string| load_words(string)}
  num.sum
end

# p load_words_sum(string_array)

# バイト数を取得
def load_bytes(str)
  str.bytesize
end

def load_bytes_sum(array)
  num = array.map{|string| load_bytes(string)}
  num.sum
end

# p load_bytes_sum(string_array)

def total(input)
  lines = load_lines_sum(input) # 行数
  words = load_words_sum(input) # 単語数
  bytes = load_bytes_sum(input) # バイト数

  print lines.to_s.rjust(8)
  print words.to_s.rjust(8)
  print bytes.to_s.rjust(8)
  puts ' total'
end


def all_data(input)
  lines = load_lines(input) # 行数
  words = load_words(input) # 単語数
  bytes = load_bytes(input) # バイト数

  print lines.to_s.rjust(8)
  print words.to_s.rjust(8)
  print bytes.to_s.rjust(8)
  # puts
end

def only_lines(input)
  lines = load_lines(input) # 行数
  print lines.to_s.rjust(8)
end

def total_lines_only(input)
  lines = load_lines_sum(input) # 行数
  print lines.to_s.rjust(8)
  puts ' total'
end



def all(array)
  array.map do |string|
    one_string = File.read(string)
    all_data(one_string)
    puts " #{load_name(string)}"
  end
end

def lines_only(array)
  array.map do |string|
    one_string = File.read(string)
    only_lines(one_string)
    puts " #{load_name(string)}"
  end
end

lines_only(condition_array)
total_lines_only(string_array)

puts ""
puts ""

all(condition_array)
total(string_array)




# # ファイル名を取得する、そのファイルがディレクトリに含まれるかどうか確認する必要がある
# # ディレクトリは削除する
# # その他のシンボリックリンクなどはどうするんだろうか？
# # 標準入力とは何だろうか？
