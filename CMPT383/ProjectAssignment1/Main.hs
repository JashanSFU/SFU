import System.Environment


main :: IO [()]
main = do
        contents <- readFile "textFormula.txt"
        let ls = lines contents
        mapM putStrLn (map checkFormula ls)