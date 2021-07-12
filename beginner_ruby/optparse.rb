require 'date'
day = Date.today
tuki = day.strftime('%m').to_i
nen = day.strftime('%Y').to_i
su = Date.new(nen, tuki, -1)
youbi_su = su.strftime('%d').to_i

su_cal = Array.new(youbi_su) do |index|
  if index < 9
    " #{index + 1} "
  else
    "#{index + 1} "
  end
end

yohaku = Date.parse("#{nen}-#{tuki}-1").strftime('%u')
puts yohaku
puts yohaku.class

print '     ' + day.strftime('%-m月') + ' '
puts day.strftime('%Y')

puts '日 月 火 水 木 金 土'

su_cal.each do |youso|
  if youso.to_i == 1
    print '   ' * yohaku.to_i + youso
  elsif Date.parse("#{nen}-#{tuki}-#{youso.to_i}").strftime('%a') == 'Sat' || youso.to_i == youbi_su
    print youso.to_s + "\n"
  else
    print youso.to_s
  end
end
