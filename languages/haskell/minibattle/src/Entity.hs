module Entity(
  nameOf
, makeDefault
, entropyAttack
, GameEntity
) where

import System.Random
import Control.Monad

data GameEntity = GameEntity {
   name         :: String
   , strength   :: Integer
   , defense    :: Integer
   , speed      :: Integer
   , magic      :: Integer
   , maxMP      :: Integer
   , hitpoints  :: Integer
   , maxHP      :: Integer
   , experience :: Integer
   , nextLevel  :: Integer
   , level      :: Integer
   }

-- Prettier printing for the custom type
instance Show GameEntity where
  show (GameEntity {name=n, strength=s, defense=d, speed=spe, magic=m,
                    maxMP=mmp, hitpoints=hp, maxHP=mhp, level=l,
                    nextLevel=nl, experience=xp}) =
    n ++ " | Level: "     ++ show l   ++ "\n"
    ++ " Strength     : " ++ show s   ++ "\n"
    ++ " Defense      : " ++ show d   ++ "\n"
    ++ " Speed        : " ++ show spe ++ "\n"
    ++ " Magic        : " ++ show m   ++ "/"  ++ show mmp ++ "\n"
    ++ " Hitpoints    : " ++ show hp  ++ "/"  ++ show mhp ++ "\n"
    ++ " Experience   : " ++ show xp  ++ "\n"
    ++ " NextLevel    : " ++ show nl

-- Get the name of the entity
nameOf :: GameEntity -> String
nameOf (GameEntity {name = n}) = n

-- Make a default instance of the player
makeDefault :: GameEntity
makeDefault = GameEntity {
  name = "Jonny the Player Slayer"
  , strength = 3
  , defense = 10
  , speed = 3
  , magic = 5
  , maxMP = 5
  , hitpoints = 10
  , maxHP = 10
  , experience = 0
  , nextLevel = 30
  , level = 1 }

-- Base attack would be str + any equipment (no eq impl atm)
baseAttack :: GameEntity -> Integer
baseAttack (GameEntity {strength=s}) = s

entropyAttack :: GameEntity -> IO Integer
entropyAttack (GameEntity {strength=str}) =
  liftM (\x -> mod x str) (randomIO :: IO Integer)

{-
-
- Attribute Setters
-
-}

setName :: GameEntity -> String -> GameEntity
setName ent v = ent { name = v }

setStrength :: GameEntity -> Integer -> GameEntity
setStrength ent v = ent { strength = v }

setDefense :: GameEntity -> Integer -> GameEntity
setDefense ent v =  ent { defense = v }

setSpeed :: GameEntity -> Integer -> GameEntity
setSpeed ent v = ent { speed = v }

setMagic :: GameEntity -> Integer -> GameEntity
setMagic ent v = ent { magic = v }

setMaxMP :: GameEntity -> Integer -> GameEntity
setMaxMP ent v = ent { maxMP = v }

setHitpoints :: GameEntity -> Integer -> GameEntity
setHitpoints ent v =  ent { hitpoints = v }

setMaxHP :: GameEntity -> Integer -> GameEntity
setMaxHP ent v = ent { maxHP = v }

setExperience :: GameEntity -> Integer -> GameEntity
setExperience ent v = ent { experience = v }

setNextLevel :: GameEntity -> Integer -> GameEntity
setNextLevel ent v = ent { nextLevel = v }

setLevel :: GameEntity -> Integer -> GameEntity
setLevel ent v = ent { level = v }

setExp :: GameEntity -> Integer -> GameEntity
setExp ent newxp = ent { experience = newxp }

