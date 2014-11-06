module MyModuleGeneric (genToStr) where

genToStr :: (Show a) => [a] -> [String]
genToStr things = map show things
