{- Fun, trivial filters to manipulate the ppm files. 
   @author Simon Symeonidis -}
module Ppm.Filters (
Direction
, revRow
, shadow
) where

import Ppm

data Direction = Left | Right | Up | Down

shadow :: [[Pixel Int]] -> [[Pixel Int]]
shadow imgdat = shadowBack imgdat 1

shadowBack :: [[Pixel Int]] -> Int -> [[Pixel Int]]
shadowBack []         i = []
shadowBack (row:rows) i = (shadowRow row i) : shadowBack rows i

shadowRow :: [Pixel Int] -> Int -> [Pixel Int]
shadowRow [] _ = []
shadowRow (p:ps) ix = safeDecreasePixel ix p : shadowRow ps (ix + 1)

safeDecrease :: Int -> Int
safeDecrease x = safeDecreaseAmt x 1

safeDecreaseAmt :: Int -> Int -> Int
safeDecreaseAmt x y = case x - y <= 0 of 
                   True  -> 0
                   False -> x - y

safeDecreasePixel :: Int -> Pixel Int -> Pixel Int
safeDecreasePixel 0  pix = pix
safeDecreasePixel ix pix = 
  makePixel (safeDecreaseAmt (redOf   pix) ix)
            (safeDecreaseAmt (blueOf  pix) ix)
            (safeDecreaseAmt (greenOf pix) ix)

revRow :: [[Pixel Int]] -> [[Pixel Int]]
revRow imgdat = revRowBack imgdat 0

revRowBack :: [[Pixel Int]] -> Int -> [[Pixel Int]]
revRowBack []         _ = []
revRowBack (row:rows) x = 
  case x `mod` 2 == 0 of
    True  -> reverse row : revRowBack rows (x + 1)
    False -> row : revRowBack rows (x + 1)
