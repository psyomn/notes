import Entity

main = do
    putStrLn "Main Player"
    let chr = Entity.makeDefault
    putStrLn $ show chr
    putStrLn ""
