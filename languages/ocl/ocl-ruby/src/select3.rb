arr = [11, 4, 0, 21, 1, 13, 24, 21, 17, 6, 21, 9, 4, 29, 11, 9, 2, 4, 5, 8]

p arr.collect{|e| e % 2 == 0}

# Output
# [false, true, true, false, false, false, true, false, false, true, false,
#  false, true, false, false, false, true, true, false, true]
