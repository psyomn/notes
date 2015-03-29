module Entity(
  nameOf
, makeDefault
, entropyAttack
) where

  import System.Random
  import Control.Monad

  data GameEntity = GameEntity {
     name :: String
     , strength :: Integer
     , defense :: Integer
     , speed :: Integer
     , magic :: Integer
     , maxMP :: Integer
     , hitpoints :: Integer
     , maxHP :: Integer
     }

  -- Prettier printing for the custom type
  instance Show GameEntity where
    show (GameEntity {name=n, strength=s, defense=d, speed=spe, magic=m,
          maxMP=mmp, hitpoints=hp, maxHP=mhp}) = n ++ "\n"
            ++ " Strength     : " ++ show s   ++ "\n"
            ++ " Defense      : " ++ show d   ++ "\n"
            ++ " Speed        : " ++ show spe ++ "\n"
            ++ " Magic        : " ++ show m   ++ "/"  ++ show mmp ++ "\n"
            ++ " Hitpoints    : " ++ show hp  ++ "/"  ++ show mhp ++ "\n"

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
    , maxHP = 10 }

  -- Base attack would be str + any equipment (no eq impl atm)
  baseAttack :: GameEntity -> Integer
  baseAttack (GameEntity {strength=s}) = s

  entropyAttack :: GameEntity -> IO Integer
  entropyAttack (GameEntity {strength=str}) =
    liftM (\x -> mod x str) (randomIO :: IO Integer)

