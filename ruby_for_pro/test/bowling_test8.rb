# frozen_string_literal: true

class Bowling
  def initialize(score)
    @score = score
    p @score
    @sc = @score[0].split(',')
    p @sc
    @basic_score = []
    @sc.each { |s| s == 'X' ? @basic_score.push(10, 0) : @basic_score.push(s.to_i) }
    @basic_score
    p @basic_score
  end

  # def scores
  #   @sc = @score[0].split(',')
  # end

  def basic_score
    shots = []
    @sc.each { |s| s == 'X' ? shots.push(10, 0) : shots.push(s.to_i) }
    shots
  end

  def array_for_spare
    shots_for_spare = []
    basic_score.each_slice(2) { |s| shots_for_spare.push(s) }
    shots_for_spare
  end

  def spare_frames
    spares = []
    array_for_spare.each_index do |index|
      spares.push(index) if array_for_spare[index].sum == 10 && array_for_spare[index][1] != 0
    end
    spares
  end

  def points_in_spare
    spare_points = 0
    spare_frames.each { |n| spare_points += array_for_spare[n + 1][0] if n != 9 }
    spare_points
  end

  def array_for_strike
    shots_for_strike = []
    @scores.each { |s| s == 'X' ? shots_for_strike.push(10) : shots_for_strike.push(s.to_i) }
    shots_for_strike
  end

  def strikes_in_array
    @scores.each_index.select { |i| @scores[i] == 'X' }
  end

  def point(str)
    array_for_strike[str]
  end

  def strike_points_extra(strx)
    point(strx + 1) + point(strx + 2)
  end

  def points_in_strikes
    points_strike = 0
    strikes_in_array.each do |num|
      points_strike += strike_points_extra(num) if !point(num + 2).nil? && !point(num + 3).nil?
    end
    points_strike
  end
end

my_score = Bowling.new(ARGV)
p my_score.basic_score.sum + my_score.points_in_spare + my_score.points_in_strikes
