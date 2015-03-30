import Entity
import Control.Monad
import LevelingEngine

strAction :: IO Integer -> IO ()
strAction val = do
    unIO <- val
    putStr $ show unIO
    putStr ", "

printSteps :: LevelingEngine -> Integer -> IO ()
printSteps    _ 0 = do
    putStrLn ""
    return ()
printSteps leng n = do
    putStrLn $ show leng
    let leng' = LevelingEngine.step leng
    printSteps leng' (n - 1)

exampleAttack :: IO ()
exampleAttack = do
    putStrLn "Main Player"
    let chr = Entity.makeDefault
    putStrLn $ show chr
    replicateM_ 10 $ strAction (Entity.entropyAttack chr)
    putStrLn ""

exampleAssassinLeveling :: IO ()
exampleAssassinLeveling = do
    let assassin = Entity.makeAssassin
    let levsys = makeLevelingEngine assassin
    printSteps levsys 4

exampleMageLeveling :: IO ()
exampleMageLeveling = do
    let mage = Entity.makeMage
    let levsys = makeLevelingEngine mage
    printSteps levsys 4

exampleGruntLeveling :: IO ()
exampleGruntLeveling = do
    let grunt = Entity.makeGrunt
    let levsys = makeLevelingEngine grunt
    printSteps levsys 4

main = do
    exampleAttack
    exampleGruntLeveling
    exampleMageLeveling
    exampleAssassinLeveling
