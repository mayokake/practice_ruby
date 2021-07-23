# frozen_string_literal: true

# calculation of bowling score in previous rules
class Bowling
  def initialize(score)
    @score = score
  end

  def scores
    @scores = @score[0].split(',').flat_map { |s| s == 'X' ? [10, 0] : s.to_i }
  end

  def basic_score
    @basic_score = scores.each_slice(2).to_a
  end

  def indx_for_strike_calc
    basic_score.filter_map.with_index do |frame, index|
      condition_for_strike_calc = frame[0] == 10 && index < 9
      index  if condition_for_strike_calc
    end
  end

  def for_strikes
    indx_for_strike_calc.map! do |item|
      if @basic_score[item + 1][0] == 10
        10 + @basic_score[item + 2][0]
      else
        @basic_score[item + 1].sum
      end
    end
  end

  def points_of_strikes
    for_strikes.sum
  end

  def indx_for_spare_calc
    @basic_score.filter_map.with_index do |_item, index|
      condition_for_spare_calc = @basic_score[index].sum == 10 && @basic_score[index][1] != 0
      index if condition_for_spare_calc
    end
  end

  def points_of_spares
    indx_for_spare_calc.sum { |n| n < 9 ? @basic_score[n + 1][0] : 0 }
  end
end

my_score = Bowling.new(ARGV)
p my_score.points_of_strikes + my_score.points_of_spares + my_score.scores.sum
# comment
