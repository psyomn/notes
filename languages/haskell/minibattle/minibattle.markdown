# Introduction

This is a small proof of concept written in Haskell, that discusses how a
leveling engine, and possible more aspects of an RPG, could benefit having a
modular design via variables, which are in fact functions. We also show the
difference and possible advantages of having such an organization.

## Entities

In RPGs, regardless whether the subject is a Hero, or a Monster, they share the
same statistics sheets (eg: strength, defense, magic, and more), so we can
generalize this to some data type called `Entity`. In our _Haskell_ program, we
will name our `Entity` to `GameEntity`.

Essentially, we may define a simple entity, in the following way:

~~~~haskell
    data EntityClass = Grunt | Mage | Assassin deriving (Show,Eq)

    data GameEntity = GameEntityC {
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
       , entClass   :: EntityClass
       }
~~~~

All of this should not be a big surprise. Most of the source code for
`GameEntity`, may be found in `src/GameEntity.hs`. Now let us look at the
leveling engine:

~~~~haskell
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
~~~~

With that sort of organization, we can dynamically bind the type of functions we
want for leveling up. For example, if after a level up, we'll require double the
experience, or an exponent of the experience. We can do similar things to grant
different buffs on level ups. For example we can assign different functions
which would selectively update different attributes (strength, intelligence,
etc) of the entity, and compose them with any other buffs or debuffs we see fit.

We can see such examples in the following snippet of code.

~~~~haskell
    makeDoubleExp :: LevelingEngine -> LevelingEngine
    makeDoubleExp leng@(LevelingEngineC {entity=e}) =
        leng { entity = incrLevel (setNextLevel e ((getNextLevel e) * 2)) }

    makeExpontExp :: LevelingEngine -> LevelingEngine
    makeExpontExp leng@(LevelingEngineC {entity=e}) =
        leng { entity = incrLevel (setNextLevel e (makeExpontExpCalc (getNextLevel e)))}

    makeExpontExpCalc :: Integer -> Integer
    makeExpontExpCalc currLevel =
        floor $ (exp 1) ** (fromIntegral (currLevel + 1))
~~~~

And given an entity, we may set the appropriate buffs per level this way:

~~~~haskell
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
~~~~


