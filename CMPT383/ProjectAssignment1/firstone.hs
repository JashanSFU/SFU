import qualified Data.Map.Strict as Map
import System.IO 
import Data.Map.Strict
type VarAsgn = Map.Map VarId Bool

type VarId = String

data Prop = Const Bool
    | Var VarId
    | Not Prop
    | And Prop Prop
    | Or Prop Prop
    | Imply Prop Prop
    | Iff Prop Prop
    deriving (Eq, Read, Show)


findVarIds :: Prop -> [VarId]
findVarIds (Var v) = [v]
findVarIds (Not prop) = findVarIds prop
findVarIds (And prop1 prop2) = (findVarIds prop1) ++ (findVarIds prop2)
findVarIds (Or prop1 prop2) =  (findVarIds prop1) ++ (findVarIds prop2)
findVarIds (Imply prop1 prop2) =  (findVarIds prop1) ++ (findVarIds prop2)
findVarIds (Iff prop1 prop2) =  (findVarIds prop1) ++ (findVarIds prop2)
findVarIds _ = []



genVarAsgns :: [VarId] -> [VarAsgn]
genVarAsgns ( firstVarId : rest) = (Map.insert (firstVarId+2) False (Map.insert (firstVarId+1) True Map.empty)) : genVarAsgns(rest)
genVarAsgns _ = []


eval :: Prop -> VarAsgn -> Bool
eval (Const True) _ = True
eval (Const False) _ = False
eval (Var varId) varAsgnValue = if ( Map.member (varId ++ "1") (varAsgnValue) )  
                                then True 
                                else False
eval (Not prop) varAsgnValue  = not (eval prop varAsgnValue)
eval (And prop1 prop2) varAsgnValue  = and [(eval prop1 varAsgnValue),(eval prop2 varAsgnValue)]
eval (Or prop1 prop2) varAsgnValue  =  or [(eval prop1 varAsgnValue),(eval prop2 varAsgnValue)]
eval (Imply prop1 prop2) varAsgnValue  = if (eval prop1 varAsgnValue) 
                                        then (eval prop2 varAsgnValue)
                                        else False
eval (Iff prop1 prop2) varAsgnValue  = if (eval prop1 varAsgnValue)
                                                then True 
                                                else (eval prop2 varAsgnValue)


sat :: Prop -> Bool
sat (Var varId) = True
sat prop =  sattemp prop (genVarAsgns(findVarIds prop))
-- sat (And prop1 prop2) = findVarIds[prop1] ++ findVarIds[prop2]
-- sat (Or prop1 prop2) =  findVarIds[prop1] ++ findVarIds[prop2]
-- sat (Imply prop1 prop2) =  findVarIds[prop1] ++ findVarIds[prop2]
-- sat (Iff prop1 prop2) =  findVarIds[prop1] ++ findVarIds[prop2]
-- sat x = x

sattemp :: Prop -> [VarAsgn] -> Bool
sattemp _ [] = False
sattemp prop (firstasgn : rest) = if (eval prop (firstasgn)) then True 
                                    else sattemp prop rest



readFormula :: String -> Prop
readFormula string = read string

{--

readFormula :: String -> Prop
readFormula string
    |   (returnindexElement words(string) 0 0) == "Const" = constructConst (returnindexElement words(string) 1 0)
    |   (returnindexElement words(string) 0 0) == "Var" = Var (returnindexElement words(string) 1 0)
    |   (returnindexElement words(string) 0 0) == "Not" = Not (readFormula (concat (removeFirstElement(string))))
    |   (returnindexElement words(string) 0 0) == "And" = And (readFormula (concat (removeFirstElement(string))))
    |   (returnindexElement words(string) 0 0) == "Or" = Or (readFormula (concat (removeFirstElement(string))))
    |   (returnindexElement words(string) 0 0) == "Imply" = Imply (readFormula (concat (removeFirstElement(string))))
    |   (returnindexElement words(string) 0 0) == "Iff" = Iff (readFormula (concat (removeFirstElement(string))))
    
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------    
-- helping readFormula

constructConst :: String -> Prop
constructConst string
    |   string == "True" = Const True
    |   string == "False" = Const False


removeFirstElement :: [String] -> [String]
removeFirstElement [] = []
removeFirstElement (first : rest) = rest


returnindexElement :: [String] -> Int -> Int -> String
returnindexElement [] _ _ = ""
returnindexElement (first : rest) index currentIndex = if (currentIndex == index) then first
                                                                                  else returnindexElement rest index (currentIndex+1)
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

--}


checkFormula :: String -> String
checkFormula string = if (sat (readFormula string)) then "SAT" 
                    else "UNSAT"

main :: IO()
main = do
    formulasFile <- readFile "textFormula.txt"
    formula      <- hGetContents formulasFile
    print formula