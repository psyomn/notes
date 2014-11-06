{- Using the infix operator, trying to make more concise code.
   @author Simon Symeonidis -}

module Main(main) where

import Text.Printf

bottlesPlurals :: Int -> String
bottlesPlurals x = case x == 1 of
    True  -> "bottle"
    False -> "bottles"

bottles :: Int -> String -> String
0 `bottles` str = "No more " ++ (bottlesPlurals 0) ++ str
x `bottles` str = (show x) ++ " " ++ (bottlesPlurals x) ++ str

makeSong :: Int -> String
makeSong 0 = ""
makeSong x = 
  x `bottles` " of beer on the wall, " ++
  x `bottles` "  of beer. " ++ "Take one down and pass it around, " ++
  (x - 1) `bottles` " of beer on the wall. " ++ makeSong (x - 1)

main = do
  printf $ makeSong 99

