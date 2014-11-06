
module Fractals (
fibonacciWord
) where

fibonacciWord :: Floating a => a -> a
fibonacciWord phi = 3 * (log phi) / (log ( (3 + sqrt 13) / 2))

-- mandelBrot :: Floating a => a -> a
