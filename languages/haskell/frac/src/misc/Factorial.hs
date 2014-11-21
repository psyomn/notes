module Factorial(myfactorial) where

myfactorial :: Int -> Int
myfactorial n =
  case n > -1 of
    True  -> factorialback n
    False -> error "Please supply positive integers"

factorialback :: Int -> Int
factorialback 0 = 1
factorialback n = n * factorialback (n - 1)
