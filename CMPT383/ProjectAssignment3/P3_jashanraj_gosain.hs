import qualified Data.Map.Strict as Map
import System.IO
import System.Environment


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Types
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

type VarId = String
data Type = TInt
 | TBool
 | TArr Type Type
 deriving (Eq, Ord, Read, Show)

data Expr = CInt Int
 | CBool Bool
 | Var VarId
 | Plus Expr Expr
 | Minus Expr Expr
 | Equal Expr Expr
 | ITE Expr Expr Expr
 | Abs VarId Type Expr
 | App Expr Expr
 | LetIn VarId Type Expr Expr
 deriving (Eq, Ord, Read, Show)

type Env =  Map.Map VarId Type


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 2
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
typingArith :: Maybe Type -> Maybe Type -> Maybe Type
typingArith (Just TInt) (Just TInt) = (Just TInt)
typingArith _ _ = Nothing

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 3
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
typingEq :: Maybe Type -> Maybe Type -> Maybe Type
typingEq (Just TInt) (Just TInt) = (Just TBool)
typingEq (Just TBool) (Just TBool) = (Just TBool)
typingEq _ _ = Nothing

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 4
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
typing :: Env -> Expr -> Maybe Type
typing env (CInt _) = Just TInt
typing env (CBool _) = Just TBool
typing env (Var var) = (Map.lookup var env)
typing env (Plus e1 e2) = case (typing env e1) of
                                (Just TInt) -> case (typing env e2) of
                                                    (Just TInt) -> (Just TInt)
                                                    _           -> Nothing
                                _           -> Nothing
typing env (Minus e1 e2) = case (typing env e1) of
                                (Just TInt) -> case (typing env e2) of
                                                    (Just TInt) -> (Just TInt)
                                                    _           -> Nothing
                                _           -> Nothing
typing env (Equal e1 e2) = case (typing env e1) of 
                                (Just TBool) -> case (typing env e2) of 
                                                    (Just TBool) -> (Just TBool)
                                                    _            -> Nothing
                                (Just TInt)  -> case (typing env e2) of 
                                                    (Just TInt) -> (Just TBool)
                                                    _            -> Nothing
                                _            -> Nothing
typing env (ITE c t e) = case (typing env c) of
                            (Just TBool) -> let v1 = typing env t
                                                v2 = typing env e
                                            in if v1 == v2 then v1 else Nothing
                            _ -> Nothing
typing env (Abs v t1 e) = case (typing (Map.insert v t1 env) e) of
                                    (Just t2)    -> Just (TArr t1 t2)
                                    _            -> Nothing
typing env (App e1 e2) = case (typing env e1) of 
                                (Just (TArr t1 t2)) -> let v2 = typing env e2
                                                       in if v2 == (Just t1) then (Just t2) else Nothing
                                _                   -> Nothing   
typing env (LetIn var t e1 e2) = let  v1 = (typing (Map.insert var t env) e1)
                                      v2 = (typing (Map.insert var t env) e2) 
                                 in if v1 == v2 then v2 else Nothing 

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 5
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
readExpr :: String -> Expr
readExpr string = read string

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 6
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
typeCheck :: Expr -> String
typeCheck expr = case (typing Map.empty expr) of
                    (Just t) -> show t
                    _        -> "Type Error" 


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 7
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
main :: IO ()
main = do
        args <- getArgs
        let filePath = head(args)
        stringExpressions <- readFile filePath
        let stringExpressionsList = lines stringExpressions
        let expressionsList = map readExpr stringExpressionsList 
        mapM_ putStrLn (map typeCheck expressionsList)
