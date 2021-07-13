# frozen_string_literal: true

require 'etc'
require 'optparse'

@parameter = ARGV.getopts('lar')

# Dir.chdir('/usr/bin')
# Dir.chdir("/Users/masataka_ikeda")
# p Dir.pwd

def array_decide
  @parameter['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
end

def array_decided
  @parameter['r'] ? array_decide.reverse : array_decide
end

def array_for_symlink
  array_decided.map do |file|
    File.lstat(file).ftype == 'link' ? File.lstat(file) : File.stat(file)
  end
end

def n_col
  3
end

def len_of_array
  array_decide.size
end

def wid_of_row
  array_decide.map(&:size).max
end

def len_of_row
  (len_of_array.divmod(n_col)[1]).zero? ? len_of_array.divmod(n_col)[0] : len_of_array.divmod(n_col)[0] + 1
end

def add_str
  if len_of_array.divmod(n_col)[1] != 0
    len_of_row - len_of_array.divmod(len_of_row)[1]
  else
    0
  end
end

def final_array
  add_add = Array.new(add_str, '')
  saigo_no_hairetsu = array_decided + add_add
  thr_dim3 = []
  saigo_no_hairetsu.each_slice(len_of_row) { |s| thr_dim3 << s }
  thr_dim3
end

def trans_array
  final_array.transpose
end

def fig
  trans_array[0].size
end

def normal_display(ary)
  ary.transpose.each do |file|
    file.each.with_index do |elemental, index|
      if index == fig - 1
        print "#{elemental.ljust(wid_of_row)}\n"
      else
        print elemental.ljust(wid_of_row)
      end
    end
  end
end

normal_display(final_array) if @parameter['l'] == false

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
  hash2 = {'7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x', '0' =>'---' }
  hash2[num_string]
end

  #   end
# end
  # def rwx(num_string)
#   case num_string
#   when '7'
#     'rwx'
#   when '6'
#     'rw-'
#   when '5'
#     'r-x'
#   when '4'
#     'r--'
#   when '3'
#     '-wx'
#   when '2'
#     '-w-'
#   when '1'
#     '--x'
#   when '0'
#     '---'
#   end
# end

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
  if local_mode == '4' && sticky_mode == '1'
    'r-T'
  elsif local_mode == '5' && sticky_mode == '1'
    'r-t'
  else
    rwx(local_mode)
  end
end

def file_permission(file1)
  arr_atribute = []
  arr_atribute << file_type(file1)
  arr_atribute << file_mode_owner(file1)
  arr_atribute << file_mode_group(file1)
  arr_atribute << file_mode_other(file1)
  arr_atribute.join.ljust(11)
end

def file_and_permission
  array_for_symlink.map do |file|
    file_permission(file)
  end
end

def number_of_links
  array_for_symlink.map do |file|
    file.nlink.to_s.rjust(3)
  end
end

def uid
  array_for_symlink.map do |file|
    Etc.getpwuid(file.uid).name.rjust(6)
  end
end

def gid
  array_for_symlink.map do |file|
    Etc.getgrgid(file.gid).name.rjust(6)
  end
end

def size
  array_for_symlink.map do |file|
    file.size.to_s.rjust(9)
  end
end

def date
  array_for_symlink.map do |file|
    year = file.mtime.year.to_s
    month = file.mtime.month.to_s
    day = file.mtime.day.to_s
    time_ob = file.mtime.strftime('%H:%M')
    if ((Time.now - file.mtime) / 60 / 60 / 24).round > 365 / 2
      "#{month.rjust(2)} #{day.rjust(2)} #{year}"
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
      ''
    end
  end
end

def blocks_number
  array_for_symlink.map(&:blocks)
end

def matrix
  matrix = []
  matrix << file_and_permission
  matrix << number_of_links
  matrix << uid
  matrix << gid
  matrix << size
  matrix << date
  matrix << array_decided
  matrix << symlink
end

def another_display(mtx)
  mtx.transpose.each do |file|
    file.each.with_index do |elemental, index|
      if file.size == index + 1
        print "#{elemental} \n"
      else
        print "#{elemental} "
      end
    end
  end
end

if @parameter['l'] == true
  puts "total #{blocks_number.sum}"
  another_display(matrix)
end
