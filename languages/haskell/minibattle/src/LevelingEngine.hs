module LevelingEngine (
) where

import Entity

-- Given some game entity, when leveling up, depending on bound function,
-- the next level to be reached will require an amount of experience
-- defined by that function.
--
-- Also, the modifications of the entities attributes will be modified in
-- a similar way.
data LevelingEngine = LevelingEngine {
       entity :: GameEntity
     , fnappl :: GameEntity -> GameEntity
     , attrup :: GameEntity -> GameEntity
     }

makeDoubleExp :: LevelingEngine -> LevelingEngine
makeDoubleExp leng@(LevelingEngine {entity=e}) =
    leng { entity = setExp e ((getExp e) * 2) }

makeExpontExp :: LevelingEngine -> LevelingEngine
makeExpontExp leng = leng

processAttrUp :: LevelingEngine -> LevelingEngine
processAttrUp leng = leng
