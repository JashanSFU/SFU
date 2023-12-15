import System.IO
import System.Environment
import ParserHelper

data Prop = Const Bool
 | Var String
 | Not Prop
 | And Prop Prop
 | Or Prop Prop
 | Imply Prop Prop
 | Iff Prop Prop
 deriving (Eq, Read, Show)

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Question 4
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
constant :: Parser Prop
constant = token checkConstant 

checkConstant :: Parser Prop 
checkConstant = do char 'T' 
                   return (Main.Const True)
                    <|> do char 'F'
                           return (Main.Const False)

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Question 5
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

var :: Parser Prop
var = token checkVar

checkVar :: Parser Prop
checkVar = do x <- lower
              xs <- many(alphanum)
              return (Main.Var (x:xs))

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Question 6
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

formula :: Parser Prop 
formula = token checkFormula

impTerm1 :: Parser Prop
impTerm1 = token checkImpTerm1

impTerm2 :: Parser Prop
impTerm2 = token checkImpTerm2

impTerm3 :: Parser Prop
impTerm3 = token checkImpTerm3

impTerm4 :: Parser Prop
impTerm4 = token checkImpTerm4

factor :: Parser Prop
factor = token checkFactor

checkFormula :: Parser Prop
checkFormula = do t1 <- impTerm1
                  symbol "<->"
                  f <- formula
                  return (Iff t1 f)
                  <|>
                  impTerm1

checkImpTerm1 :: Parser Prop
checkImpTerm1 = do t2 <- impTerm2
                   symbol "->"
                   t1 <- impTerm1
                   return (Imply t2 t1)
                   <|>
                   impTerm2

checkImpTerm2 :: Parser Prop
checkImpTerm2 = do t3 <- impTerm3
                   symbol "\\/"
                   t2 <- impTerm2
                   return (Or t3 t2)
                   <|>
                   impTerm3

checkImpTerm3 :: Parser Prop
checkImpTerm3 = do t4 <- impTerm4
                   symbol "/\\"
                   t3 <- impTerm3
                   return (And t4 t3)
                   <|>
                   impTerm4

checkImpTerm4 :: Parser Prop
checkImpTerm4 = do symbol "!"
                   f <- formula
                   return (Not f)
                   <|>
                   factor

checkFactor :: Parser Prop
checkFactor = do symbol "("
                 f <- formula
                 symbol ")"
                 return f
                 <|> 
                 constant
                 <|> 
                 var

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Question 7
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

parseFormula :: String -> String
parseFormula value = case (parse formula value) of 
                      []    -> "Parse Error"
                      ((x, []): _) -> show x
                      ((x, _): _) -> "Parse Error"

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Question 8
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

main :: IO ()
main = do
        args <- getArgs
        let filePath = head(args)
        formulas <- readFile filePath
        let formulasList = lines formulas
        mapM_ putStrLn (map parseFormula formulasList)