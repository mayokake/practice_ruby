# frozen_string_literal: true

require 'optparse'

p ARGV
parameter = ARGV.getopts('l')
p parameter

# array_for_a_option = Dir.glob('*', File::FNM_DOTMATCH)
array_for_b_option = Dir.glob('*')
# array_get = array_for_b_option.map do |string|
#   string.
# end

# p File.stat(array_for_b_option[1]).ftype

array_get = 
array_for_b_option.filter_map do |string| 
  string if File.stat(string).ftype == 'file' 
end

p array_get
# p array_get.select {|string| File.stat(string).ftype == 'file'}



##### empty?


# p array_for_a_option
# p array_for_b_option

p test1 = ARGV.select { |string| array_get.include?(string)}
# p test1.size
# p test2 = ARGV.map {|string| array_for_b_option.include?(string) }



# if ARGV == []
#   input = $stdin.read
# else
#   puts "$0：#{$0}"
#   ARGV.each_with_index do |arg, i|
#   puts "ARGV[#{i}]：#{arg}"
#   end
# end


# 標準入力を受け取る
# input = $stdin.read

# 行数を取得
def load_lines(str)
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

# all_data(input)





# puts "$0：#{$0}"
# ARGV.each_with_index do |arg, i|
#   puts "ARGV[#{i}]：#{arg}"
# end

# array_for_a_option = Dir.glob('*', File::FNM_DOTMATCH)
# p array_for_a_option
# p array_for_a_option.size
# # p array_for_a_option.include?(ARGV[0])
# p test1 = ARGV.select { |array| array_for_a_option.include?(array)}
# p test1.size
# p test2 = ARGV.map {|array| array_for_a_option.include?(array) }


# # ファイル名を取得する、そのファイルがディレクトリに含まれるかどうか確認する必要がある
# # ディレクトリは削除する
# # その他のシンボリックリンクなどはどうするんだろうか？
# # 標準入力とは何だろうか？
