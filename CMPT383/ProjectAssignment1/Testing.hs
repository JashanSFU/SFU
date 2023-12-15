import qualified Data.Map.Strict as Map
import System.IO
import Data.List

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
findVarIds (And prop1 prop2) = nub ((findVarIds prop1) ++ (findVarIds prop2))
findVarIds (Or prop1 prop2) = nub ((findVarIds prop1) ++ (findVarIds prop2))
findVarIds (Imply prop1 prop2) =  nub ((findVarIds prop1) ++ (findVarIds prop2))
findVarIds (Iff prop1 prop2) =  nub ((findVarIds prop1) ++ (findVarIds prop2))
findVarIds _ = []


genVarAsgns :: [VarId] -> [VarAsgn]
genVarAsgns [] = []
genVarAsgns ( firstVarId : rest) =   (addingToVarAsgns (firstVarId) (genVarAsgns(rest)) True) ++ (addingToVarAsgns (firstVarId) (genVarAsgns(rest)) False)

addingToVarAsgns :: VarId -> [VarAsgn] -> Bool -> [VarAsgn]
addingToVarAsgns firstVarId [] value = [Map.insert (firstVarId) value (Map.empty)]
addingToVarAsgns firstVarId varAsgnArray value = addingAsgns firstVarId varAsgnArray value

addingAsgns :: VarId -> [VarAsgn] -> Bool -> [VarAsgn]
addingAsgns firstVarId [] value = []
addingAsgns firstVarId (firstVarAsgn : rest) value  = (Map.insert (firstVarId) (value) (firstVarAsgn)) : (addingAsgns firstVarId rest value)



eval :: Prop -> VarAsgn -> Bool
eval (Const x) _ = x
eval (Var varId) varAsgnValue = if ( Map.lookup (varId) (varAsgnValue) == (Just True) )  
                                then True 
                                else False
eval (Not prop) varAsgnValue  = not (eval prop varAsgnValue)
eval (And prop1 prop2) varAsgnValue  = and [(eval prop1 varAsgnValue),(eval prop2 varAsgnValue)]
eval (Or prop1 prop2) varAsgnValue  =  or [(eval prop1 varAsgnValue),(eval prop2 varAsgnValue)]
eval (Imply prop1 prop2) varAsgnValue  = if ( (eval prop1 varAsgnValue) && not (eval prop2 varAsgnValue) )
                                            then False
                                            else True
eval (Iff prop1 prop2) varAsgnValue  = if ((eval prop1 varAsgnValue) == (eval prop2 varAsgnValue)) 
                                        then True
                                        else False



sat :: Prop -> Bool
sat (Const x) = x
sat (Var varId) = True
sat prop =  sattemp1 prop (genVarAsgns(findVarIds prop)) 0


sattemp1 :: Prop -> [VarAsgn] -> Int -> Bool
sattemp1 prop [] number = if number == 0 
                            then (eval prop Map.empty)
                            else False
sattemp1 prop (firstasgn : rest) _ = if (eval prop (firstasgn)) then True 
                                    else sattemp1 prop rest 1


readFormula :: String -> Prop
readFormula string = read string


checkFormula :: String -> String
checkFormula string = if (sat (readFormula string)) then "SAT" 
                    else "UNSAT"

testing :: IO ()
testing = do
        contents <- readFile "textFormula.txt"
        let ls = lines contents
        mapM_ putStrLn (map checkFormula ls)