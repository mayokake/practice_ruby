# frozen_string_literal: true

class Bowling
  def initialize(score)
    @score = score
  end

  def scores
    debug_with_sleep('scores')
    scores = @score[0].split(',')
    @scores = scores
  end

  def basic_score
    debug_with_sleep('basic_score')
    shots = []
    scores.each { |s| s == 'X' ? shots.push(10, 0) : shots.push(s.to_i) }
    shots
    @shots = shots
  end

  def array_for_spare
    debug_with_sleep('array_for_spare')
    shots_for_spare = []
    @shots.each_slice(2) { |s| shots_for_spare.push(s) }
    shots_for_spare
    @shots_for_spare = shots_for_spare
  end

  def spare_frames
    debug_with_sleep('spare_frames')
    spares = []
    array_for_spare.each_index do |index|
      spares.push(index) if @shots_for_spare[index].sum == 10 && @shots_for_spare[index][1] != 0
    end
    spares
  end

  def points_in_spare
    debug_with_sleep('points_in_spare')
    spare_points = 0
    spare_frames.each { |n| spare_points += @shots_for_spare[n + 1][0] if n != 9 }
    spare_points
  end

  def array_for_strike
    debug_with_sleep('array_for_strike')
    shots_for_strike = []
    @scores.each { |s| s == 'X' ? shots_for_strike.push(10) : shots_for_strike.push(s.to_i) }
    p shots_for_strike
    @shots_for_strike = shots_for_strike
  end

  def strikes_in_array
    debug_with_sleep('strikes_in_array')
    @scores.each_index.select { |i| @scores[i] == 'X' }
  end

  def point(str)
    array_for_strike[str]
  end

  def strike_points_extra(strx)
    point(strx + 1) + point(strx + 2)
  end

  def points_in_strikes
    debug_with_sleep('points_in_strikes')    
    points_strike = 0
    strikes_in_array.each do |num|
      points_strike += strike_points_extra(num) if !point(num + 2).nil? && !point(num + 3).nil?
    end
    points_strike
  end

  def debug_with_sleep(name)
    puts name
    sleep 0.1
  end
end

my_score = Bowling.new(ARGV)
p my_score.basic_score.sum + my_score.points_in_spare + my_score.points_in_strikes
