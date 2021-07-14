# frozen_string_literal: true

require 'etc'
require 'optparse'

# class 配列を得るクラス
# 少なくともファイル・タイプを得るクラス
# あるいは、Longオプション用の表示クラス


@parameter = ARGV.getopts('lar')

Dir.chdir('/usr/bin')
# Dir.chdir("/Users/masataka_ikeda")
# p Dir.pwd

def array_for_a_option
  @parameter['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
end

def array_for_r_option
  @parameter['r'] ? array_for_a_option.reverse : array_for_a_option
end

def array_for_stat
  array_for_r_option.map do |file|
    File.lstat(file).ftype == 'link' ? File.lstat(file) : File.stat(file)
  end
end

def number_of_columns
  3
end

def length_of_array
  array_for_a_option.size
end

def width_of_row
  array_for_a_option.map(&:size).max
end

def length_of_row
  if (length_of_array.divmod(number_of_columns)[1]).zero?
    length_of_array.divmod(number_of_columns)[0]
  else
    length_of_array.divmod(number_of_columns)[0] + 1
  end
end

def for_add_strings
  if length_of_array.divmod(number_of_columns)[1] != 0
    length_of_row - length_of_array.divmod(length_of_row)[1]
  else
    0
  end
end

def array_for_transpose
  ary = array_for_r_option + Array.new(for_add_strings, '')
  three_dimension_array = []
  ary.each_slice(length_of_row) { |s| three_dimension_array << s }
  three_dimension_array
end

def array_in_transpose
  array_for_transpose.transpose
end

def number_of_colums
  array_in_transpose[0].size
end

def output_display(array)
  array.transpose.each do |file|
    file.each.with_index do |elemental, index|
      if index == number_of_colums - 1
        print "#{elemental.ljust(width_of_row)}\n"
      else
        print elemental.ljust(width_of_row)
      end
    end
  end
end

output_display(array_for_transpose) if @parameter['l'] == false



# class 

def file_type(file1)
  hash1 = { 'file' => '-', 'directory' => 'd', 'characterSpecial' => 'c', 'blockSpecial' => 'b',
            'fifo' => 'p', 'link' => 'l', 'socket' => 's', 'unknown' => '?' }
  hash1[file1.ftype]
end

def rwx(num_string)
  hash2 = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x',
            '0' => '---' }
  hash2[num_string]
end

def id(num_string2)
  hash3 = { '7' => 'rws', '6' => 'rwS', '5' => 'r-s', '4' => 'r-S', '3' => '-ws', '2' => '-wS', '1' => '--s',
            '0' => '--S' }
  hash3[num_string2]
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
  array_for_stat.map do |file|
    file_permission(file)
  end
end

def number_of_links
  array_for_stat.map do |file|
    file.nlink.to_s.rjust(4)
  end
end

def uid
  array_for_stat.map do |file|
    Etc.getpwuid(file.uid).name.rjust(6)
  end
end

def gid
  array_for_stat.map do |file|
    Etc.getgrgid(file.gid).name.rjust(6)
  end
end

def size
  array_for_stat.map do |file|
    file.size.to_s.rjust(9)
  end
end

def year(file)
  file.mtime.year.to_s.rjust(5)
end

def month(file)
  file.mtime.month.to_s.rjust(2)
end

def day(file)
  file.mtime.day.to_s.rjust(2)
end

def time_ob(file)
  file.mtime.strftime('%H:%M')
end

def date
  array_for_stat.map do |file|
    if ((Time.now - file.mtime) / 60 / 60 / 24).round > 365 / 2
      "#{month(file)} #{day(file)} #{year(file)}"
    else
      "#{month(file)} #{day(file)} #{time_ob(file)}"
    end
  end
end

def symlink
  array_for_r_option.map.with_index do |file, index|
    if array_for_stat[index].symlink?
      "-> #{File.readlink(file)}"
    else
      ''
    end
  end
end

def blocks_number
  array_for_stat.map(&:blocks)
end

def matrix
  matrix = []
  matrix << file_and_permission
  matrix << number_of_links
  matrix << uid
  matrix << gid
  matrix << size
  matrix << date
  matrix << array_for_r_option
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
