function isFunny(humorLevel)
  return humorLevel > 9000
end

function computeAdd(a,b)
  return a + b
end

function computeSub(a,b)
  return a - b
end

println("hello potatoface")
println("Is that guy funny? " * string(isFunny(9001)))

println("Print elements inside an array")
arr = [1,2,3,4]
for el in arr
  println(string(el))
end

# Function addresses inside of an array

println("Printing things using functions in array")
arrF = [computeAdd, computeSub]

for f in arrF
  println(string(f(2,5)))
end


# Can we have an array with different types?
arrDiff = [1, 2, 3, 2.3, true]
