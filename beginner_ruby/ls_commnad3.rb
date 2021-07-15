# frozen_string_literal: true

require 'etc'
require 'optparse'

Dir.chdir('/usr/bin')
# Dir.chdir("/Users/masataka_ikeda")
# p Dir.pwd

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
end

class MatrixForNoL
  def initialize(array)
    @array = array
  end

  def number_of_columns
    3
  end

  def length_of_array
    @array.size
  end

  def width_of_row
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
    divisible_array.map { |string| string.ljust(width_of_row)}
  end

  def array_for_transpose
    three_dimension_array = []
    size_ajustment.each_slice(length_of_row) { |string| three_dimension_array << string }
    three_dimension_array
  end

  def transposed_array
    array_for_transpose.transpose
  end
end

class MatrixForL
  def initialize(array1, array2)
    @array1 = array1
    @array2 = array2
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
    @array1.map do |file|
      file_permission(file)
    end
  end
  
  def number_of_links
    @array1.map do |file|
      file.nlink.to_s.rjust(4)
    end
  end
  
  def uid
    @array1.map do |file|
      Etc.getpwuid(file.uid).name.rjust(6)
    end
  end
  
  def gid
    @array1.map do |file|
      Etc.getgrgid(file.gid).name.rjust(6)
    end
  end
  
  def size
    @array1.map do |file|
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
    @array1.map do |file|
      if ((Time.now - file.mtime) / 60 / 60 / 24).round > 365 / 2
        "#{month(file)} #{day(file)} #{year(file)}"
      else
        "#{month(file)} #{day(file)} #{time_ob(file)}"
      end
    end
  end

  def symlink
    @array2.map.with_index do |file, index|
      if @array1[index].symlink?
        "-> #{File.readlink(file)}"
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
    matrix << file_and_permission
    matrix << number_of_links
    matrix << uid
    matrix << gid
    matrix << size
    matrix << date
    matrix << @array2
    matrix << symlink
  end

  def transposed_matrix
    matrix.transpose
  end
end



def output_display(array)
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

def output_with_long(mtx)
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

array_with_no_l_option = MatrixForNoL.new(for_ar_option)
matrix1 = array_with_no_l_option.transposed_array

array_with_l_option = MatrixForL.new(for_statlink, for_ar_option)
matrix2 = array_with_l_option.transposed_matrix

if condition == true
  puts "total #{array_with_l_option.blocks_number.sum}"
  output_with_long(matrix2)
else
  output_display(matrix1)
end
