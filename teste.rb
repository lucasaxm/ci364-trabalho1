#!/usr/bin/ruby

def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end

puts is_numeric?(5)
puts is_numeric?("5")
puts is_numeric?("5aa")