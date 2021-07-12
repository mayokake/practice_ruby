# 3-1
a = 2
def hantei(a)
  puts "#{a}は整数365より小さい" if a < 365
end
hantei(a)

a = 2
puts a < 365

puts a == 1 + 1

# 3-2
season = '春'
puts 'あんまん食べたい' if season != '夏'
# 3-3
season = '夏'
if season == '夏'
  puts 'かき氷食べたい'
  puts '麦茶のみたい'
end

# 3-3
wallet = 100
if wallet >= 120
  puts 'ジュースを買おう'
else
  puts 'お金じゃ買えない幸せがたくさんあるんだ'
end

# 3-4
x = 200
puts '範囲外です' if x <= 0 || x >= 100
x = 0
y = -1
z = 1
puts '正の数です' if x > 0 || y > 0 || z > 0

# 3-5
season = '春'
case season
when '春'
  puts 'アイスを買っていこう！'
when '夏'
  puts 'かき氷を買っていこう！'
else
  puts 'あんまんを買っていこう！'
end

# 3-6
2.times do
  puts 'latte'
  2.times do
    puts 'mocca'
  end
end
puts 'captino'
