{- 
  This contains some fractals that may be used in order to generate different
  information, that can then be pipped to some other image library. This is 
  here purely for math stuff. 

  @author Simon Symeonidis 
-}
module Fractals.Simple (
julia
, makePlane
, slice
, calculate
, calculateColored
, calculateBool) where

import Data.Complex
import Ppm

type CxDouble = Complex Double

maxIterations :: Int
maxIterations = 255

-- |The function allows setting a C of whatever value, but for the sake of 
--   simplicity, we're going to use 0 
julia :: CxDouble -> CxDouble
-- julia z = z * z + ( (-0.835) :+ (-0.232) )
-- julia z = z * z + ( (-0.4) :+ (-0.6) )
-- julia z = z * z + ( (-0.8) :+ (0.156) )
-- julia z = z * z + ( (-0.70176) :+ (-0.3842) )
-- julia z = z * z + ( (-0.835) :+ (-0.2321) )
julia z = z * z + ( (-0.51) :+ (0.5315) )


-- | Check if the given point, after two iterations of a fractal function will
--   be greater than the radius 2 (there was a theory somewhere that I read
--   that generally if two iterations are greater than 2, then the point will
--   go to infinity).
toInfinity :: (CxDouble -> CxDouble) -> CxDouble -> Bool
toInfinity f point = 2 < (euclidean $ f $ f point)

euclidean :: CxDouble -> Double
euclidean cmp = 
  sqrt $ (realPart cmp) ** 2 + (imagPart cmp) ** 2 

-- | Create a cartesian plane composed by xs and ys 
makePlane x1 x2 xpix y1 y2 ypix =
  [y :+ x | x <- (makeRange x1 x2 xpix), y <- (makeRange y1 y2 ypix)]

-- | The range that we're interested in (for example -2 -> 2). 
makeRange :: Double -> Double -> Double -> [Double]
makeRange min max dist = 
  reverse $ makeRangeBack min max (grain min max dist) dist

-- | Slice an array to smaller arrays of `n' size
slice :: Int -> [a] -> [[a]]
slice _  []  = []
slice n arr = take n arr : slice n (drop n arr)

-- | Create a distribution of values in the given array
--   dist is the distribution (how many elements)
--   min is the minimum
--   max is the maximum
makeRangeBack :: Double -> Double -> Double -> Double -> [Double]
makeRangeBack _    _    _  (-1) = []
makeRangeBack min max step curr = 
  min + step * curr : makeRangeBack min max step (curr - 1)

-- | Check out how much each step should be in magnitude given two cartesian
--   points, and the length of the actual picture that portrays it.
grain x y d = ((abs x) + (abs y)) / d

-- | Calculating each coordinate, and spitting out the ensuing plane
calculate :: (CxDouble -> CxDouble) -> [[CxDouble]] -> [[CxDouble]]
calculate _ []     = []
calculate f (x:xs) = map f x : calculate f xs

-- | This is to be used if we're just going to make something that displays
--   black and white. I mainly wrote and am using this in order to debug while
--   keeping fingers crossed that I undestood all the theory / articles I read
--   about fractals.
calculateBool :: (CxDouble -> CxDouble) -> [[CxDouble]] -> [[Bool]]
calculateBool _ []     = []
calculateBool f (x:xs) = map (toInfinity f) x : calculateBool f xs

-- | Make a colored fractal
calculateColored :: (CxDouble -> CxDouble) -> [[CxDouble]] -> [[Pixel Int]]
calculateColored _     [] = []
calculateColored f (x:xs) = 
  map (funcIterationsPixel f) x : calculateColored f xs

funcIterationsPixel :: (CxDouble -> CxDouble) -> CxDouble -> Pixel Int
funcIterationsPixel f ipoint = 
  makePixel 0 (funcIterations f ipoint) (funcIterations f ipoint)

funcIterations :: (CxDouble -> CxDouble) -> CxDouble -> Int
funcIterations f ipoint = funcIterationsBack f ipoint 0

-- | Responsible to actually calculate how many iterations until the point
--   reaches distance > 2
--   f      is the function to apply
--   ipoint is the imaginary point
--   acc    is the accumulator
funcIterationsBack f ipoint acc =
  case euclidean(f ipoint) < 2 && acc < maxIterations of
    True  -> funcIterationsBack f (f ipoint) (acc + 1)
    False -> acc

-- | return a pixel color depending on the magnitude of displacement
colorByMagnitude :: Double -> Pixel Int
colorByMagnitude x 
  | x < 0.2 = makePixel 255   0   0
  | x < 0.3 = makePixel   0 255   0
  | x < 0.4 = makePixel 255 255 255
  | x < 0.5 = makePixel 255 255 255
  | x < 0.6 = makePixel 190 190 190
  | x < 0.7 = makePixel 200 200 230
  | x < 1.0 = makePixel 200 230 200
  | x < 1.5 = makePixel 230 200 200
  | x < 2   = makePixel 200 200 200
  | x < 10  = makePixel  30   0   0
  | x < 20  = makePixel 100   0   0
  | x < 30  = makePixel   0 100   0
  | x < 50  = makePixel   0   0 100
  | x < 60  = makePixel 100 100   0
  | x > 59  = makePixel   0   0 100
  
