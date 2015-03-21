# Add the exists method
class Array
  def exists(&block)
    self.collect{|e| block.call(e)}.inject{|sum,e| sum || e}
  end
end

arr = [1,2,3,4,9001]
p arr.exists{|e| e > 9000}

# output
#   true
