-- @author Simon Symeonidis 
module MyModule(toStrList) where

-- | Example where we convert an integer list to a string list. The signature
-- is on the first line bellow. The second line below it uses the map function
-- performing `show` on each element which converts it to a String. We return
-- a list of strings, as specified by the signature.
toStrList :: [Int] -> [String]
toStrList lst = map show lst

-- Example usage:
-- [psyomn@aeolus misc 0]$ ghci MyModule.hs 
-- GHCi, version 7.6.3: http://www.haskell.org/ghc/  :? for help
-- Loading package ghc-prim ... linking ... done.
-- Loading package integer-gmp ... linking ... done.
-- Loading package base ... linking ... done.
-- [1 of 1] Compiling MyModule         ( MyModule.hs, interpreted )
-- Ok, modules loaded: MyModule.
-- *MyModule> toStrList [1,2,3,4,12313,123123123,231]
-- ["1","2","3","4","12313","123123123","231"]


