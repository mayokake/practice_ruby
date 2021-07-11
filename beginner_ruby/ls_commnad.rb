require 'etc'

def array_decided
  parameter = {a: true}
  parameter[:a] ? Dir.glob("*") : Dir.glob("*", File::FNM_DOTMATCH)
end

def array_for_symlink
  array_decided.map do |file|
    File.lstat(file).ftype == 'link' ? File.lstat(file) : File.stat(file)
  end
end

def file_type(file1)
  local_file = file1.ftype
  case local_file
  when 'file' 
    '-'
  when 'directory'
    'd'
  when 'characterSpecial'
    'c'
  when 'blockSpecial'
    'b'
  when 'fifo'
    'p'
  when 'link'
    'l'
  when 'socket'
    's'
  when 'unknown'
    '?'
  end
end

def rwx(num_string)
  case num_string
  when '7'
    'rwx'
  when '6'
    'rw-'
  when '5'
    'r-x'
  when '4'
    'r--'
  when '3'
    '-wx'
  when '2'
    '-w-'
  when '1'
    '--x'
  when '0'
    '---'
  end
end

def id(num_string2)
  case num_string2
  when '7'
    'rws'
  when '6'
    'rwS'
  when '5'
    'r-s'
  when '4'
    'r-S'
  when '3'
    '-ws'
  when '2'
    '-wS'
  when '1'
    '--s'
  when '0'
    '--S'
  end
end

def file_mode_owner(file1)
  local_mode = file1.mode.to_s(8).slice(-3)
  id_mode = file1.mode.to_s(8).slice(-4)
  if id_mode == '4'
    id(local_mode)
  else
   rwx(local_mode)
  end
end

def file_mode_group(file1)
  local_mode = file1.mode.to_s(8).slice(-2)
  id_mode = file1.mode.to_s(8).slice(-4)
  if id_mode == '2'
    id(local_mode)
  else
   rwx(local_mode)
  end
end

def file_mode_other(file1)
  local_mode = file1.mode.to_s(8).slice(-1)
  sticky_mode = file1.mode.to_s(8).slice(-4)
  if local_mode ==  '4' && sticky_mode == '1'
    'r-T'
  elsif local_mode == '5' && sticky_mode == '1'
    'r-t'
  else
    rwx(local_mode)
  end
end

def file_permission(file1)
  arr_atribute = []
  # test_permission = []
  arr_atribute << file_type(file1)
  arr_atribute << file_mode_owner(file1)
  arr_atribute << file_mode_group(file1)
  arr_atribute << file_mode_other(file1)
  arr_atribute.join.ljust(11)
  # test_permission << arr_atribute.join
  # p test_permission
end

# p file_permission(array_for_symlink[0]).class

def file_and_permission
  # file_p_array = []
  array_for_symlink.map do |file|
    file_permission(file)
  end
  # file_p_array
end

def number_of_links
  array_for_symlink.map do |file|
    file.nlink.to_s.rjust(2)
  end
end

def uid
  array_for_symlink.map do |file|
    Etc.getpwuid(file.uid).name
  end
end

def gid
  array_for_symlink.map do |file|
    Etc.getgrgid(file.gid).name
  end
end

def size
  array_for_symlink.map do |file|
    file.size.to_s.rjust(6)
  end
end

def date
  array_for_symlink.map do |file|
    year = file.mtime.year.to_s
    month = file.mtime.month.to_s
    day = file.mtime.day.to_s
    time_ob = file.mtime.strftime("%H:%M")
    if ((Time.now - file.mtime)/60/60/24).round > 365/2
      " 1 1 #{time_ob}" 
    else
    "#{month.rjust(2)} #{day.rjust(2)} #{time_ob}"
    end
  end
end

def symlink
  array_decided.map.with_index do |file, index|
    if array_for_symlink[index].symlink?
      "-> #{File.readlink(file)}"
    else 
      ""
    end
  end
end

def blocks_number
  array_for_symlink.map do |file|
    file.blocks
  end
end

puts "total #{blocks_number.sum}"
# p array_for_symlink[0].blocks


# input_file_name = array_decided[4]
# p File.readlink(input_file_name)

# p File.readlink(array_for_symlink[0].to_s)
# p File.symlink?(array_decided[0])

# p array_for_symlink[0].symlink?


# for_diff = array_for_symlink[0].mtime
# p array_for_symlink[0].mtime.year
# time_now = Time.now
# p time_diff = time_now - for_diff
# p (time_diff/60/60/24).round.to_s



# p year = array_for_symlink[0].mtime.year.to_s
# p month = array_for_symlink[0].mtime.month.to_s
# p day = array_for_symlink[0].mtime.day.to_s
# p time_ob = array_for_symlink[0].mtime.strftime("%H:%M")

# p "#{month.rjust(2)} #{day.rjust(2)} #{time_ob}"

# p array_for_symlink[0].mtime.strftime "%m %d %Y %H:%M" 
# p array_for_symlink[0].size


matrix = []
matrix << file_and_permission
matrix << number_of_links
matrix << uid
matrix << gid
matrix << size
matrix << date
matrix << array_decided
matrix << symlink

# p matrix
# p matrix.transpose


matrix.transpose.each do |file|
  file.each.with_index do |elemental, index|
    if file.size == index + 1
      print elemental + " " + "\n"
    else
      print elemental + " "
    end
  end
end

#### -l 指定がない場合の表示は、インシャルで3列とか、5列とかその数字をつかって後でいかようにも変更できるようにしよう！

# ぼっちを最後のシンボリックリンクの名称で使えるかも


# p file_type(array_for_symlink[0])
# a = []
# a << file_type(array_for_symlink[0])
# p a

# array_for_symlink.each do |file|
#   p file_type(file)
# end




# # p array_map[-1].mode
# # p array_map[-1].ftype

# # def ary
# #   parameter[:a] ? Dir.glob("*") : Dir.glob("*", File::FNM_DOTMATCH)
# # end


# # file_test = array_test[0]
# # p file_test
# # p Dir.glob("*", File::FNM_DOTMATCH)

# # test_mode = File.stat('optparse.rb')
# # p test_mode.mode
# # ファイルの各種情報は配列に入れて、後で取り出せるようにしよう。EachとPrintで取得すればいい。
# # printf 数字の変換には %とか、これを使うといいと思いついたはず

# # p $0
# # fs = File::Stat.new($0)
# # printf "%o\n", fs.mode
# # p fs.mode.class
# # p fs.mode

# test_file = File.stat($0)
# p test_file
# p test_file.mode.to_s(8)
# p test_file.mode.to_s(8).slice(-3, 3)
# p test_file.mode.to_s(8).slice(0, 2)
# p test_file.mode.to_s(8).slice(2)
# p test_file.mode.to_s(8).slice(3)
# p test_file.mode.to_s(8).slice(4)
# p test_file.mode.to_s(8).slice(5)
# p test_file.ftype




# # p file_type(array_map[-1])

# # def ftp
# #   array_map.each do |element|
# #     puts file_type(element)
# #   end
# # end

# # p ftp



# # def owner
# # end

# # def permission(file)

# # end




# # puts fs.mode  #=> 33188
# # puts fs.mode.to_s(8).class #=> 100644
# # printf "%o\n", fs.mode #=> 100644

# # test1111 = Dir.glob("*")

# # p test1111[0]
# # .mode.to_s(8).slice(-3.3)


# # p fs.mode.to_s(8).slice(-3, 3)
# # p fs.mode.to_s(8).slice(0, 2)
# # p fs.mode.to_s(8).slice(2)
# # p fs.mode.to_s(8).slice(3)
# # p fs.mode.to_s(8).slice(4)
# # p fs.mode.to_s(8).slice(5)


Dir.chdir("/usr/bin")
p Dir.pwd
p test1212 = Dir.glob("su")
# #   p Dir.glob("*", File::FNM_DOTMATCH)
# # end
# # p Dir.pwd

# p test1212[0]
# test1213 = File.stat(test1212[0])
# p test1213
# puts  test1213.mode.to_s(8)
# p file_mode_owner(test1213)
# p file_mode_group(test1213)

# puts  File.stat(test1111[0]).mode

# p test1111
