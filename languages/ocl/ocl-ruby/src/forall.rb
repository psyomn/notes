
class Array
  # @param block is a code block that you pass to this method (your predicate)
  def forAll(&block)
    self.collect{|e| block.call(e)}.inject{|sum,e| sum && e}
  end
end

arr = [2,4,6,8]
p arr.forAll{|e| e % 2 == 0}

# Same array as above, but has 9, 11 as well
arr += [9, 11]
p arr.forAll{|e| e % 2 == 0}

# output
#   true
#   false
