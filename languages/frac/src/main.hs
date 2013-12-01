-- @author Simon Symeonidis 
--   Trying to make a haskell output some pretty fractal graphics
module Main(main) where

import Text.Printf

import Ppm 
import Ppm
import Ppm.Patterns
import Ppm.Filters

import Fractals.Simple

pixelBool b = 
  case b == True of
    True  -> (Pixel 255 255 255)
    False -> (Pixel   0   0   0)

buildImage     [] = [] 
buildImage (x:xs) = map pixelBool x : buildImage xs

maxPlaneX = 2000
maxPlaneY = 2000
plane     = makePlane (-2) 2 maxPlaneX (-2) 2 maxPlaneY
slplane   = slice (2001) plane 
-- ^ +1 because each row has 0.0 as a point

boolPlane  = calculateBool    julia slplane
colorPlane = calculateColored julia slplane

imgDataBool = buildImage boolPlane

main = do
  let image = makeRedImage 2001 2000
  let out   = setData image colorPlane
  printf $ outputImage out

