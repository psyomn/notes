module LevelingEngine (
  LevelingEngine
, makeLevelingEngine
, step
) where

import Entity

-- Given some game entity, when leveling up, depending on bound function,
-- the next level to be reached will require an amount of experience
-- defined by that function.
--
-- Also, the modifications of the entities attributes will be modified in
-- a similar way.
data LevelingEngine = LevelingEngineC {
       entity  :: GameEntity
     , expappl :: LevelingEngine -> LevelingEngine
     , attrup  :: GameEntity -> GameEntity
     }

instance Show LevelingEngine where
    show(LevelingEngineC {entity = e}) = show e

makeLevelingEngine :: GameEntity -> LevelingEngine
makeLevelingEngine ent =
    LevelingEngineC {
      entity  = ent
    , expappl = makeDoubleExp
    , attrup  = autoAttrUpAssign ent
    }

step :: LevelingEngine -> LevelingEngine
step leng@(LevelingEngineC {entity=e, expappl=ex, attrup=up}) = do
    let lengAppliedAttrUp = leng { entity = up e }
    let lengAppliedExp    = ex lengAppliedAttrUp
    lengAppliedExp

makeDoubleExp :: LevelingEngine -> LevelingEngine
makeDoubleExp leng@(LevelingEngineC {entity=e}) =
    leng { entity = incrLevel (setNextLevel e ((getNextLevel e) * 2)) }

makeExpontExp :: LevelingEngine -> LevelingEngine
makeExpontExp leng@(LevelingEngineC {entity=e}) =
    leng { entity = incrLevel (setNextLevel e (makeExpontExpCalc (getNextLevel e)))}

makeExpontExpCalc :: Integer -> Integer
makeExpontExpCalc currLevel = floor $ (exp 1) ** (fromIntegral (currLevel + 1))

processAttrUp :: LevelingEngine -> LevelingEngine
processAttrUp leng = leng

autoAttrUpAssign :: GameEntity -> (GameEntity -> GameEntity)
autoAttrUpAssign ent
    | isGrunt    ent = attrUpGrunt
    | isMage     ent = attrUpMage
    | isAssassin ent = attrUpAssassin
    | otherwise      = attrUpGrunt

attrUpGrunt :: GameEntity -> GameEntity
attrUpGrunt ent =
    setStrength (incrHP ent 5)
                (getStrength ent + 3)

attrUpMage :: GameEntity -> GameEntity
attrUpMage ent =
    setMaxMP (incrHP ent 3)
             (getMaxMP ent + 3)

attrUpAssassin :: GameEntity -> GameEntity
attrUpAssassin ent =
    setSpeed (incrHP ent 4)
             (getSpeed ent + 5)

incrHP :: GameEntity -> Integer -> GameEntity
incrHP ent up = setMaxHP ent (getMaxHP ent + up)

incrLevel :: GameEntity -> GameEntity
incrLevel ent = setLevel ent (getLevel ent + 1)

