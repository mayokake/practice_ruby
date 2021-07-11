a = 4
eval a


require "optparse"
require "date"

# オプションから引数(年と月）を受け取るためのクラスを定義
class YearMonth
  def initialize
    @options = {}
    opts = OptionParser.new
      opts.on("-y [YEAR]") { |year| @options[:y] = year }
      opts.on("-m [MONTH]") { |month| @options[:m] = month }
      opts.parse!(ARGV)
      @year = :y
      @month = :m
  end

  def get_year
    if @options.include?(@year) && @options[@year] != nil
      @options[@year].to_i
    else
      Date.today.strftime("%Y").to_i
    end
  end

  def get_month
    if @options.include?(@month) && @options[@month] != nil
       @options[@month].to_i
    else
       Date.today.strftime("%m").to_i
    end
  end
end

 
=begin
# # def spare
# #   spares = score
# #   spares.delete("X")
# #   spares.map{|s| s.to_i}
# # end

# # p spare

# # sh = []
# # spare_hanbetu = spare.each_slice(2){|a| sh << a}
# # p sh


# # sh.map{|m| p m.sum}

# # def test_for_spare
# #   conv_strike.map.with_index do |num, index|
# #     if num == 10
# #       [num.to_i, 0]
# #     else
# #       [num.to_i, index % 2]
# #     end
# #   end
# # end

# # p test_for_spare

# frames = []
# conv_strike.each_slice(2) do |s|
#   frames << s
# end
# # p frames


# # p score
# # p strike
# # p conv_strike
# # p point(3)
# # p strike_points_extra(0)

# # p strike_frames

# # shots = []
# # scores.each do |s|
# #   if s == 'X'
# #     shots << 10
# #   else
# #     shots << s.to_i
# #   end
# # end

# # p shots

# # frames = []
# # shots.each_slice(2) do |s|

# #   frames << s
# # end
# # p frames

# # test  = shots.map.with_index do |num, index|
# #   if num == 10
# #     p [num.to_i, 0]
# #   else
# #     p [num.to_i, index % 2]
# #   end
# # end

# # p test


# # test.each do |arry|
# #   p arry
# #   arry.each do |x|
# #     p x
# #   end
# # end
 
# # p scores

# # i = 0
# # fl = []
# # testaay = shots.map do |n|
# #   if n == 10
# #     fl <<  0
# #     i = i
# #     [n, 0]
# #   else 
# #     fl <<  i % 2
# #     i += 1
# #     [n, i % 2]
# #   end
# # end

# # p testaay

# # point = 0
# # points = []
# # testaay.each do |mini_array|
# #   points << mini_array[0]


# #   if mini_array[0] == 10
# #     p mini_array[0]
# #   end
# # end
=end
