import Entity
import Control.Monad

strAction :: IO Integer -> IO ()
strAction val = do
    unIO <- val
    putStr $ show unIO
    putStr ", "

main = do
    putStrLn "Main Player"
    let chr = Entity.makeDefault
    putStrLn $ show chr
    replicateM_ 10 $ strAction (Entity.entropyAttack chr)
    putStrLn ""
