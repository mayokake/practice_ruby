# frozen_string_literal: true

require 'etc'
require 'optparse'

Dir.chdir('/usr/bin')
# Dir.chdir('/usr/sbin')
# Dir.chdir("/Users/masataka_ikeda")
# p Dir.pwd

# Get the basic array for the output and constant needed in other class
class ArrayForMatrix
  def initialize
    @parameter = ARGV.getopts('lar')
  end

  def array_for_a_option
    @parameter['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def array_for_ar_option
    @parameter['r'] ? array_for_a_option.reverse : array_for_a_option
  end

  def l_option
    @parameter['l']
  end

  def array_for_stat
    array_for_ar_option.map do |string|
      File.lstat(string).ftype == 'link' ? File.lstat(string) : File.stat(string)
    end
  end

  def string_uid
    array_for_stat.map do |stat|
      stat.uid
    end
  end

  def uid
    string_uid.map do |id|
      Etc.getpwuid(id).name
    end
  end

  def width_of_uid
    uid.map(&:size).max
  end

  def string_gid
    array_for_stat.map do |stat|
      stat.gid
    end
  end

  def gid
    string_gid.map do |id|
      Etc.getgrgid(id).name
    end
  end

  def width_of_gid
    gid.map(&:size).max
  end
end

# Describing the matrix without the long option
class MtxForNoL
  def initialize(array)
    @array = array
  end

  def number_of_columns
    3
  end

  def length_of_array
    @array.size
  end

  def width_of_row #for adjustment of the width of file names displayed
    @array.map(&:size).max > 25 ? @array.map(&:size).max : 25
  end

  def length_of_row
    if (length_of_array.divmod(number_of_columns)[1]).zero?
      length_of_array.divmod(number_of_columns)[0]
    else
      length_of_array.divmod(number_of_columns)[0] + 1
    end
  end

  def number_of_adding_strings
    if length_of_array.divmod(number_of_columns)[1] != 0
      length_of_row - length_of_array.divmod(length_of_row)[1]
    else
      0
    end
  end

  def divisible_array
    @array + Array.new(number_of_adding_strings, '')
  end

  def size_ajustment
    divisible_array.map { |string| string.ljust(width_of_row) }
  end

  def matrix_for_transpose
    three_dimension_array = []
    size_ajustment.each_slice(length_of_row) { |string| three_dimension_array << string }
    three_dimension_array
  end

  def transposed_matrix_without_l_option
    matrix_for_transpose.transpose
  end
end

# file permission
class ModeAndPermission
  def initialize(array1)
    @array1 = array1
  end

  def file_type(file)
    hash1 = { 'file' => '-', 'directory' => 'd', 'characterSpecial' => 'c', 'blockSpecial' => 'b',
              'fifo' => 'p', 'link' => 'l', 'socket' => 's', 'unknown' => '?' }
    hash1[file.ftype]
  end

  def rwx(number)
    hash2 = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x',
              '0' => '---' }
    hash2[number]
  end

  def id(number)
    hash3 = { '7' => 'rws', '6' => 'rwS', '5' => 'r-s', '4' => 'r-S', '3' => '-ws', '2' => '-wS', '1' => '--s',
              '0' => '--S' }
    hash3[number]
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

  def file_and_permission
    @array1.map do |stat|
      file_permission(stat)
    end
  end
end

# Describing the matrix with the long option
class MtxForL
  def initialize(array1, array2, array3, array4, array5)
    @array1 = array1
    @array2 = array2
    @array3 = array3
    @array4 = array4
    @array5 = array5
  end

  def number_of_links
    @array1.map do |stat|
      stat.nlink.to_s.rjust(4)
    end
  end

  def string_uid
    @array1.map do |stat|
      stat.uid
    end
  end

  def uid
    @array1.map do |stat|
      Etc.getpwuid(stat.uid).name.rjust(@array4)
    end
  end

  def gid
    @array1.map do |stat|
      Etc.getgrgid(stat.gid).name.rjust(@array5)
    end
  end

  def size
    @array1.map do |stat|
      stat.size.to_s.rjust(9)
    end
  end

  def year(stat)
    stat.mtime.year.to_s.rjust(5)
  end

  def month(stat)
    stat.mtime.month.to_s.rjust(2)
  end

  def day(stat)
    stat.mtime.day.to_s.rjust(2)
  end

  def time_ob(stat)
    stat.mtime.strftime('%H:%M')
  end

  def date
    @array1.map do |stat|
      if ((Time.now - stat.mtime) / 60 / 60 / 24).round > 365 / 2
        "#{month(stat)} #{day(stat)} #{year(stat)}"
      else
        "#{month(stat)} #{day(stat)} #{time_ob(stat)}"
      end
    end
  end

  def symbolic_link
    @array2.map.with_index do |string, index|
      if @array1[index].symlink?
        "-> #{File.readlink(string)}"
      else
        ''
      end
    end
  end

  def blocks_number
    @array1.map(&:blocks)
  end

  def matrix
    matrix = []
    matrix << @array3
    matrix << number_of_links
    matrix << uid
    matrix << gid
    matrix << size
    matrix << date
    matrix << @array2
    matrix << symbolic_link
  end

  def transposed_matrix
    matrix.transpose
  end
end

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

basic_array = ArrayForMatrix.new

for_ar_option = basic_array.array_for_ar_option
for_statlink = basic_array.array_for_stat

condition = basic_array.l_option

width_uid = basic_array.width_of_uid
width_gid = basic_array.width_of_gid

array_with_no_l_option = MtxForNoL.new(for_ar_option)
matrix1 = array_with_no_l_option.transposed_matrix_without_l_option

permissions = ModeAndPermission.new(for_statlink)
argument_of_permissions = permissions.file_and_permission

array_with_l_option = MtxForL.new(for_statlink, for_ar_option, argument_of_permissions, width_uid, width_gid)
matrix2 = array_with_l_option.transposed_matrix

if condition == true
  puts "total #{array_with_l_option.blocks_number.sum}"
  output_with_l_option(matrix2)
else
  output_without_l_option(matrix1)
end
