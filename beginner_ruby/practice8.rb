# 8-1
# 問1
a = {:cofee => 300, :caffe_latte => 400}.class
puts a
## "puts ({:cofee => 300, :caffe_latte => 400}).class !!!!! こうする必要がある"

# 8-1
# 2
hash = Hash.new
puts hash

# 8-2
# 3
class Caffe_latte
end
la = Caffe_latte.new
puts la.class

# 8-3
# 4
class Item
  def name
    "チーズケーキ"
  end
end

cake = Item.new
puts cake.name

# 8-4
# 5
class Item
  def name=(text)
    @name = text
  end
  def name
    @name
  end
end

item = Item.new
item.name = "チーズケーキ"
puts item.name

# 8-5
# 6
class Item
  def initialize
    puts "商品を扱うオブジェクト"
  end
end

Item.new

# 8-5
# 7
class Item
  def initialize(text)
    @name = text
  end
  def name
    @name 
  end
end

item1 = Item.new("マフィン")
item2 = Item.new("スコーン")

puts item1.name
puts item2.name

# 8-6
# 8
class Drink
  def self.todays_special
    "ホワイトモカ"
  end
end

puts Drink.todays_special
# Drink.todays_special

# 8-7
# 9
class Item
  def name
    @name
  end
  def name=(text)
    @name = text
  end
end

class Food < Item
end

food1 = Food.new
food1.name = "チーズケーキ"
puts food1.name