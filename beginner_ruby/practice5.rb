# 5-1
p %w[coffee latte].size
puts [1, 2, 3, 4, 5].sum

# 5-2
p %w[mocca latte mocca].uniq
p %w[mocca latte mocca].uniq!.clear

# 5-3
puts %w[mocca latte mocca].sample

def omikuji
  puts %w[大吉 中吉 末吉 凶].sample
end

omikuji

# 5-4
p [100, 50, 300].sort
p [100, 50, 300].sort.reverse
p 'cba'.reverse

# 5-5
p [100, 50, 300].join(' ')
p '100,50,300'.split(',')

# 5-6
p [1, 2, 3].map { |x| x * 3 }
p %w[abc xyz].map { |x| x.reverse }
p %w[aya achi Tama].map { |x| x.downcase }.sort
