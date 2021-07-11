# frozen_string_literal: true

class Bowling
  def initialize(score)
    @score = score
  end

  def scores
    @score[0].split(',')
  end

  def spare
    shots = []
    scores.each do |s|
      if s == 'X'
        shots.push(10, 0)
      else
        shots.push(s.to_i)
      end
    end
    shots
  end

  def spare_test
    shots_for_spare = []
    spare.each_slice(2) do |s|
      shots_for_spare << s
    end
    shots_for_spare
  end

  # def spare_frames
  #   spares = []
  #   spare_test.each_with_index do |_n, index|
  #     spares << index if spare_test[index].sum == 10 && spare_test[index][1] != 0
  #   end
  #   spares
  # end

  def spare_frames
    spares = []
    spare_test.each_index do |index|
      spares << index if spare_test[index].sum == 10 && spare_test[index][1] != 0
    end
    spares
  end

  def total_spares
    spare_score = 0
    spare_frames.each do |n|
      spare_score += spare_test[n + 1][0] if n != 9
    end
    spare_score
  end

  def strike_test
    shots_for_strike = []
    scores.each do |s|
      if s == 'X'
        shots_for_strike.push(10)
      else
        shots_for_strike.push(s.to_i)
      end
    end
    shots_for_strike
  end

  def strikes
    scores.each_index.select { |i| scores[i] == 'X' }
  end

  def point(str)
    strike_test[str]
  end

  def strike_points_extra(strx)
    point(strx + 1) + point(strx + 2)
  end

  def p_of_strike
    points_strike = 0
    strikes.each do |num|
      points_strike += strike_points_extra(num) if !point(num + 2).nil? && !point(num + 3).nil?
    end
    points_strike
  end
end

my_score = Bowling.new(ARGV)
p my_score.spare.sum + my_score.total_spares + my_score.p_of_strike

p File.expand_path(__FILE__) 
