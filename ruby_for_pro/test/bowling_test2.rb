# frozen_string_literal: true

def score
  ARGV[0].split(',')
end

def for_spare
  shots = []
  score.each do |s|
    if s == 'X'
      shots.push(10, 0)
    else
      shots.push(s.to_i)
    end
  end
  shots
end

p for_spare

def for_for_spare
  frames = []
  for_spare.each_slice(2) do |s|
    frames << s
  end
  frames
end

def spare_frames
  spares = []
  for_for_spare.each_with_index do |_n, index|
    spares << index if for_for_spare[index].sum == 10 && for_for_spare[index][1] != 0
  end
  spares
end

def spare_point(spf)
  for_for_spare[spf + 1][0]
end

points_spare = 0
spare_frames.each do |n|
  points_spare += spare_point(n) if n != 9
end

def strike
  score.each_index.select { |i| score[i] == 'X' }
end

p strike

def conv_strike
  score.map.with_index do |number, i|
    score[i] = if score[i] == 'X'
                 10
               else
                 number.to_i
               end
  end
end

p conv_strike

def point(str)
  conv_strike[str]
end

def strike_points_extra(strx)
  point(strx + 1) + point(strx + 2)
end

points_strike = 0
strike.each do |num|
  points_strike += strike_points_extra(num) if !point(num + 2).nil? && !point(num + 3).nil?
end

p points_strike
p points_spare
p conv_strike.sum
