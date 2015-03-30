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
