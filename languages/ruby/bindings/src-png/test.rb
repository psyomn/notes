require 'is_png'

class TestPng
  include IsPng
end

begin
  # This will go boom
  TestPng.new.is_png(12)
rescue TypeError
  puts "Rescued!"
end

begin
  puts "is png? %s" % TestPng.new.is_png("hello there")
rescue => e
  puts e.message
end

puts "is png? %s" % TestPng.new.is_png("test.png")
