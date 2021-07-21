# frozen_string_literal: true

require 'etc'
require 'optparse'

# Dir.chdir('/usr/bin')
# Dir.chdir('/usr/sbin')
# Dir.chdir("/Users/masataka_ikeda")
# p Dir.pwd

parameter = ARGV.getopts('lar')

l_option = parameter['l']

array_for_a_option = parameter['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
array_for_ar_option = parameter['r'] ? array_for_a_option.reverse : array_for_a_option

array_for_stat = array_for_ar_option.map {|string| File.lstat(string).ftype == 'link' ? File.lstat(string) : File.stat(string) }


# Describing the matrix without the long option
array_without_l_option = array_for_ar_option
number_of_columns = 3
length_of_array_without_l_option = array_for_ar_option.size

width_of_row_without_l_option = array_for_ar_option.map(&:size).max > 25 ? array_for_ar_option.map(&:size).max : 25

condition_length = length_of_array_without_l_option.divmod(number_of_columns)
condition_length[1].zero?
length_of_row = condition_length[1].zero? ? condition_length[0] : condition_length[0] + 1
number_of_adding_strings = condition_length[1].zero? ? 0 : length_of_row - length_of_array_without_l_option.divmod(length_of_row)[1]
divisible_array = array_without_l_option + Array.new(number_of_adding_strings, '')
size_ajustment = divisible_array.map { |string| string.ljust(width_of_row_without_l_option) }
matrix_for_transpose = size_ajustment.each_slice(length_of_row).to_a

transposed_matrix_without_l_option = matrix_for_transpose.transpose

def output_without_l_option(array)
  array.each do |file|
    file.each.with_index do |elemental, index|
      if file.size == index + 1
        print "#{elemental}\n"
      else
        print elemental
      end
    end
  end
end

# p array_without_l_option

# ##### output_without_l_option(transposed_matrix_without_l_option)

# file permission
class ModeAndPermission
  def self.my_file_permission(array)
    my_file_permission = ModeAndPermission.new(array)
    my_file_permission.file_and_permission
  end

  def initialize(array1)
    @array1 = array1
    @hash1 = { 'file' => '-', 'directory' => 'd', 'characterSpecial' => 'c', 'blockSpecial' => 'b',
              'fifo' => 'p', 'link' => 'l', 'socket' => 's', 'unknown' => '?' }
    @hash2 = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x',
              '0' => '---' }
    @hash3 = { '7' => 'rws', '6' => 'rwS', '5' => 'r-s', '4' => 'r-S', '3' => '-ws', '2' => '-wS', '1' => '--s',
              '0' => '--S' }
  end

  def file_and_permission
    @array1.map do |stat|
      file_permission(stat)
    end
  end

  private

  def file_type(file)
    @hash1[file.ftype]
  end

  def rwx(number)
    @hash2[number]
  end

  def id(number)
    @hash3[number]
  end

  def file_mode_owner(file)
    local_mode = file.mode.to_s(8).slice(-3)
    id_mode = file.mode.to_s(8).slice(-4)
    if id_mode == '4'
      id(local_mode)
    else
      rwx(local_mode)
    end
  end

  def file_mode_group(file)
    local_mode = file.mode.to_s(8).slice(-2)
    id_mode = file.mode.to_s(8).slice(-4)
    if id_mode == '2'
      id(local_mode)
    else
      rwx(local_mode)
    end
  end

  def file_mode_other(file)
    local_mode = file.mode.to_s(8).slice(-1)
    sticky_mode = file.mode.to_s(8).slice(-4)
    if local_mode == '4' && sticky_mode == '1'
      'r-T'
    elsif local_mode == '5' && sticky_mode == '1'
      'r-t'
    else
      rwx(local_mode)
    end
  end

  def file_permission(file)
    arr_atribute = []
    arr_atribute << file_type(file)
    arr_atribute << file_mode_owner(file)
    arr_atribute << file_mode_group(file)
    arr_atribute << file_mode_other(file)
    arr_atribute.join.ljust(11)
  end
end

ModeAndPermission.my_file_permission(array_for_stat)

def links_uid_gid_size(array)
  links = array.map { |stat| stat.nlink.to_s.rjust(4) }
  width_of_uid = array.map { |stat| Etc.getpwuid(stat.uid).name.size }.max
  uid =  array.map { |stat| Etc.getpwuid(stat.uid).name.rjust(width_of_uid) }
  width_of_gid = array.map { |stat| Etc.getgrgid(stat.gid).name.size }.max
  gid = array.map { |stat| Etc.getgrgid(stat.gid).name.rjust(width_of_gid) }
  size = array.map {|stat| stat.size.to_s.rjust(9) }
  mini_matrix = []
  mini_matrix << links
  mini_matrix << uid
  mini_matrix << gid
  mini_matrix << size    
end

p links_uid_gid_size(array_for_stat).size

class DateClassObj
  def self.date_object(array)
    date_object = DateClassObj.new(array)
    date_object.date_display
  end

  def initialize(array)
    @array = array
  end

  def date_display
    @array.map do |stat|
      if ((Time.now - stat.mtime) / 60 / 60 / 24).round > 365 / 2
        "#{month(stat)} #{day(stat)} #{year(stat)}"
      else
        "#{month(stat)} #{day(stat)} #{time_obj(stat)}"
      end
    end
  end

  private
  
  def year(stat)
    stat.mtime.year.to_s.rjust(5)
  end

  def month(stat)
    stat.mtime.month.to_s.rjust(2)
  end
  
  def day(stat)
    stat.mtime.day.to_s.rjust(2)
  end
  
  def time_obj(stat)
    stat.mtime.strftime('%H:%M')
  end
end

# DateClassObj.date_object(array_for_stat)

symbolic_link =
array_for_ar_option.map.with_index do |string, index|
  array_for_stat[index].symlink? ? "-> #{File.readlink(string)}" : ''
end

# p blocks_number = array_for_stat.map(&:blocks)

p ModeAndPermission.my_file_permission(array_for_stat).size
p links_uid_gid_size(array_for_stat).size
p DateClassObj.date_object(array_for_stat).size
p array_for_ar_option.size
p symbolic_link.size


matrix = []
matrix << ModeAndPermission.my_file_permission(array_for_stat)
matrix = matrix + links_uid_gid_size(array_for_stat)
matrix << DateClassObj.date_object(array_for_stat)
matrix << array_for_ar_option
matrix << symbolic_link
matrix

p transposed_matrix = matrix.transpose

def output_with_l_option(mtx)
  mtx.each do |file|
    file.each.with_index do |elemental, index|
      if file.size == index + 1
        print "#{elemental} \n"
      else
        print "#{elemental} "
      end
    end
  end
end

output_with_l_option(transposed_matrix)


# if condition == true
#   puts "total #{array_with_l_option.blocks_number.sum}"
#   output_with_l_option(matrix2)
# else
#   output_without_l_option(matrix1)
# end
