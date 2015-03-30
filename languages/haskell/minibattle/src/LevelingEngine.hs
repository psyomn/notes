module LevelingEngine (
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
     , expappl :: GameEntity -> GameEntity
     , attrup  :: GameEntity -> GameEntity
     }

makeLevelingEngine :: GameEntity -> LevelingEngine
makeLevelingEngine ent =
    LevelingEngineC {
      entity  = ent
    -- , expappl = makeDoubleExp
    , attrup  = autoAttrUpAssign ent
    }

-- TODO
-- step :: LevelingEngine -> LevelingEngine

makeDoubleExp :: LevelingEngine -> LevelingEngine
makeDoubleExp leng@(LevelingEngineC {entity=e}) =
    leng { entity = setExp e ((getExp e) * 2) }

makeExpontExp :: LevelingEngine -> LevelingEngine
makeExpontExp leng@(LevelingEngineC {entity=e}) =
    leng { entity = setExp e (makeExpontExpCalc (getLevel e))}

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

