# frozen_string_literal: true


# class Bowling
#   def initialize(score)
#     @score = score
#   end

# end


scores = []
ARGV[0].split(',').each { |s| s == 'X' ? scores.push(10, 0) : scores.push(s.to_i) }

basic_score = scores.each_slice(2).to_a

# indx_for_strike_calc = []
# basic_score.each.with_index do |item, index|
#   condition_for_strike_calc = item[0] == 10 && index < 9
#   indx_for_strike_calc << index  if condition_for_strike_calc
# end

# p indx_for_strike_calc

indx_for_strike_calc = 
basic_score.filter_map.with_index do |frame, index|
  condition_for_strike_calc = frame[0] == 10 && index < 9
  index  if condition_for_strike_calc
end

# p indx_for_strike_calc

indx_for_strike_calc.map! do |item| 
  if basic_score[item + 1][0] == 10
    10 + basic_score[item + 2][0]
  else
    basic_score[item + 1].sum
  end
end

points_of_strikes =  indx_for_strike_calc.sum

indx_for_spare_calc =
basic_score.filter_map.with_index do |_item, index|
  condition_for_spare_calc = basic_score[index].sum == 10 && basic_score[index][1] != 0
  index if condition_for_spare_calc
end

p indx_for_spare_calc

# points_of_spares = 0
# indx_for_spare_calc.each { |n| points_of_spares += basic_score[n + 1][0] if n < 9 }
# p points_of_spares

points_of_spares = indx_for_spare_calc.sum { |n| n < 9 ? basic_score[n + 1][0] : 0 }

p points_of_spares


p scores.sum + points_of_strikes + points_of_spares
