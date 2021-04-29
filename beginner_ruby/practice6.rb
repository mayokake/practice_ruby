#6-1
menu = {coffee: 300, caffe_latte: 400}
p menu[:caffe_latte]
menu2 = {"モカ" => "チョコレートとミルク入り", "カフェラテ" => "ミルク入り"}
p menu2["モカ"]

#6-2-3
menu[:tea] = 300
p menu

#6-2-4
menu.delete(:coffee)
p menu

#6-2-5
menu = {coffee: 300, caffe_latte: 400} 
if menu[:tea] == nil
  puts "紅茶はありませんか？"
end

#6-2-6
menu = {coffee: 300, caffe_latte: 400} 
if menu[:caffe_latte] <= 500
  puts "カフェラテをください"
end

#6-2-7
hash = {}
hash.default = 0
array = "caffelette".chars
array.each do |x|
  hash[x] += 1
end
p hash


#6-3-8
menu = {"コーヒー" => 300, "カフェラテ" => 400}
menu.each { |key, value| puts "#{key} - #{value}円"}

#6-3-9
menu = {"コーヒー" => 300, "カフェラテ" => 400}
menu.each do |key, value| 
  if value >= 350
    puts "#{key} - #{value}円"
  end
end

#6-3-10
{}.each do |key, value| 
  if value >= 350
    puts "#{key} - #{value}円"
  end
end

#6-3-11
arry = []
menu = {"コーヒー" => 300, "カフェラテ" => 400}
menu.each_key do |key|
  arry = arry.push(key)
end
p arry


