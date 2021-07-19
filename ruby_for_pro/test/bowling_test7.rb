# frozen_string_literal: true

scores = []
ARGV[0].split(',').each { |s| s == 'X' ? scores.push(10, 0) : scores.push(s.to_i) }

basic_score = scores.each_slice(2).to_a

indx_for_strike_calc = []
basic_score.each.with_index{ |item, index| indx_for_strike_calc << index  if item[0] == 10 && index < 9}

indx_for_strike_calc.map! do |item| 
  if basic_score[item + 1][0] == 10
    10 + basic_score[item + 2][0]
  else
    basic_score[item + 1].sum
  end
end

points_of_strikes =  indx_for_strike_calc.sum

indx_for_spare_calc = []
basic_score.each_index do |index|
  indx_for_spare_calc.push(index) if basic_score[index].sum == 10 && basic_score[index][1] != 0
end

points_of_spares = 0
indx_for_spare_calc.each { |n| points_of_spares += basic_score[n + 1][0] if n < 9 }
points_of_spares

p scores.sum + points_of_strikes + points_of_spares
