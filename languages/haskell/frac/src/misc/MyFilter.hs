module MyFilter(myfilter) where

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter _ []     = []
myfilter f (x:xs) =
  case f x of
    True  -> x : myfilter f xs
    False -> myfilter f xs
