# 7-1 ##1
def order
  puts 'latte, please!'
end
order

# 7-2 ##2
def area
  3 * 3
end
puts area

# #7-2 ##3
def  dice
  puts [1, 2, 3, 4, 5, 6].sample
end
dice

# #7-3-Q4
def order(drink)
  puts "#{drink}をください"
end

order('カフェラテ')
order('モカ')

# #7-3-Q5
def dice
  a = [1, 2, 3, 4, 5, 6].sample
  puts a
  if a == 1
    puts 'もう1回'
    puts [1, 2, 3, 4, 5, 6].sample
  end
end
dice

# 7-4-Q6
def price(item:)
  case item
  when item = 'coffee' # item = は不要
    puts 300
  when item = 'latte' # item = は不要
    puts 400
  end
end

price(item: 'coffee')
price(item: 'latte')

# 別解答
def price(item:)
  items = { 'コーヒー' => 300, 'カフェラテ' => 400 }
  items[item]
end

# 7-4-Q7
def price(item:, size:)
  if item == 'コーヒー'
    if size == 'ショート'
      puts '300 + 0円'
    elsif size == 'トール'
      puts '300 + 50円'
    else
      puts '300 + 100円'
    end
  elsif item == 'カフェラテ'
    if size == 'ショート'
      puts '400 + 0円'
    elsif size == 'トール'
      puts '400 + 50円'
    else
      puts '400 + 100円'
    end
  end
end

price(item: 'カフェラテ', size: 'トール')
price(item: 'コーヒー', size: 'ベンティ')

# 7-4-Q8
def price(item:, size: 'ショート')
  if item == 'コーヒー'
    if size == 'ショート'
      puts '300 + 0円'
    elsif size == 'トール'
      puts '300 + 50円'
    else
      puts '300 + 100円'
    end
  elsif item == 'カフェラテ'
    if size == 'ショート'
      puts '400 + 0円'
    elsif size == 'トール'
      puts '400 + 50円'
    else
      puts '400 + 100円'
    end
  end
end

price(item: 'カフェラテ', size: 'トール')
price(item: 'コーヒー', size: 'ベンティ')

# 7-5-9
def order(drink)
  puts "#{drink}をください"
end

drink = 'coffee'
order(drink)
