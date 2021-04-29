#4-1
arr = ["coffee", "latte"]
p arr

#4-2
drinks = ["coffee", "latte", "mocca"]
puts drinks[1]
puts drinks.first
puts drinks.last

#4-3
p ["coffee", "latte"].push("mocca")
p [2, 3].unshift(1)
p [1, 2] + [3, 4]

#4-4
["tea latte", "cafe latte", "macha latte"].each do |x|
  puts x
end

["tea latte", "cafe latte", "macha latte"].each do |x|
  puts "#{x} をお願いします"
end

sum = 0
[1, 2, 3].each do |x|
  sum = x + sum
end
puts sum

[].each do |x|
  puts x
end
