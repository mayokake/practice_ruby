# 9-1
# 1
module ChocolateChip
  def Chocolate_chip
    @name += "チョコレートチップ" 
  end
end

ChocolateChip

# 2
module ChocolateChip
  def chocolate_chip
    @name += "チョコレートチップ" 
  end
end

class Drink
  include ChocolateChip
  def initialize(name)
    @name = name
  end
  def name
    @name
  end
end

drink = Drink.new("抹茶")
drink.chocolate_chip
puts drink.name

# 9-2
# 3
module EspressoShot
  Price = 100
end

puts EspressoShot::Price

# 9-3
# 4
module WhippedCream
  def self.info
    "whipped cream for topping "
  end
end

puts WhippedCream.info