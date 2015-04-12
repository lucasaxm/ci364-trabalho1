#!/usr/bin/ruby

def read_file(file_name)
  file = File.open(file_name, "r")
  data = file.read
  file.close
  return data
end

puts "Start"
puts read_file("input")
puts "End"