import System.IO
import System.Environment
import Prelude
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Control.Monad.State.Lazy

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Type and data declarations
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

type VarId = String

data Expr = CInt Int
 | CBool Bool
 | Var VarId
 | Plus Expr Expr
 | Minus Expr Expr
 | Equal Expr Expr
 | ITE Expr Expr Expr
 | Abs VarId Expr
 | App Expr Expr
 | LetIn VarId Expr Expr
 deriving (Eq, Ord, Read, Show)

data Type = TInt
 | TBool
 | TError
 | TVar Int
 | TArr Type Type
 deriving (Eq, Ord, Read, Show)

data Constraint = CEq Type Type
 | CError
 deriving (Eq, Ord, Read, Show)

type ConstraintSet = Set.Set Constraint
type ConstraintList = [Constraint]

type Substitution = Map.Map Type Type
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 1
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

type Env = Map.Map VarId Type

type InferState a = State Int a

type RelabelState a = State (Map.Map Int Int) a

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Given Functions
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

relabel :: Type -> Type
relabel t = evalState (go t) Map.empty
    where
        go :: Type -> RelabelState Type
        go TInt = return TInt
        go TBool = return TBool
        go TError = return TError
        go (TVar x) = do m <- get
                         case Map.lookup x m of
                            Just v  -> return (TVar v)
                            Nothing -> do let n = 1 + Map.size m
                                          put (Map.insert x n m)
                                          return (TVar n)
        go (TArr t1 t2) = do t1' <- go t1
                             t2' <- go t2
                             return (TArr t1' t2')


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 2
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

getFreshTVar :: InferState Type
getFreshTVar = do v <- get
                  put (v+1)
                  return (TVar v)


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 3
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

infer :: Env -> Expr -> InferState (Type, ConstraintSet)
infer g (CInt _) = return (TInt, Set.empty)
infer g (CBool _) = return (TBool, Set.empty)
infer g (Var var) =  case (Map.lookup var g) of
                        Nothing        -> return (TError,Set.fromList [CError])
                        (Just t)       -> return (t,Set.empty)
infer g (Plus e1 e2) = do (t1,c1) <- infer g e1
                          (t2,c2) <- infer g e2
                          return (TInt, Set.union (Set.union c1 c2) (Set.fromList [CEq t1 TInt , CEq t2 TInt]))
infer g (Minus e1 e2) = do (t1,c1) <- infer g e1
                           (t2,c2) <- infer g e2
                           return (TInt, Set.union (Set.union c1 c2) (Set.fromList [CEq t1 TInt , CEq t2 TInt]))
infer g (Equal e1 e2) = do (t1,c1) <- infer g e1
                           (t2,c2) <- infer g e2
                           return (TBool, Set.union (Set.union c1 c2) (Set.fromList [CEq t1 t2]))
infer g (ITE e1 e2 e3) = do (t1,c1) <- infer g e1
                            (t2,c2) <- infer g e2
                            (t3,c3) <- infer g e3
                            return (t2, Set.union (Set.union (Set.union c1 c2) c3) (Set.fromList [CEq t1 TBool , CEq t2 t3])) 
infer g (Abs x e) = do y <- getFreshTVar
                       (t, c) <- infer (Map.insert x y g) e
                       return (TArr y t, c)
infer g (App e1 e2) = do x1 <- getFreshTVar
                         x2 <- getFreshTVar
                         (t1, c1) <- infer g e1
                         (t2, c2) <- infer g e2 
                         return (x2, Set.union (Set.union c1 c2) (Set.fromList [CEq t1 (TArr x1 x2), CEq t2 x1]))
infer g (LetIn x e1 e2) = do x1 <- getFreshTVar
                             (t1, c1) <- infer (Map.insert x x1 g) e1
                             (t2, c2) <- infer (Map.insert x x1 g) e2 
                             return (t2, Set.union (Set.union c1 c2) (Set.fromList [CEq x1 t1]))


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 4
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

inferExpr :: Expr -> (Type, ConstraintSet)
inferExpr e = case infer Map.empty e of
                   m ->  evalState m 1

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 5
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

toCstrList :: ConstraintSet -> ConstraintList
toCstrList set = Set.toList set


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 6
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

applySub :: Substitution -> Type -> Type
applySub _ (TError) = TError
applySub _ (TInt)  = TInt
applySub _ (TBool) = TBool
applySub s (TVar v)   = case (Map.lookup (TVar v) s) of 
                            Nothing -> (TVar v)
                            Just t  -> t
applySub s (TArr t1 t2) = let type2 = applySub s t2
                              type1 = applySub s t1
                          in (TArr type1 type2)
                             
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 7
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

applySubToCstrList :: Substitution -> ConstraintList -> ConstraintList
applySubToCstrList _ [] = []
applySubToCstrList s ((CEq t1 t2): xs) = (CEq (applySub s t1) (applySub s t2)) : (applySubToCstrList s xs) 
applySubToCstrList s ((CError): xs) = (CError) : (applySubToCstrList s xs)


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 8
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

composeSub :: Substitution -> Substitution -> Substitution
composeSub s1 s2 = Map.union (fmap (applySub s1) s2) s1

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 9
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

tvars :: Type -> Set.Set Type
tvars (TVar i)     = Set.fromList [TVar i]
tvars (TArr t1 t2) = let set1 = tvars t1
                         set2 = tvars t2
                     in (Set.union set1 set2)
tvars _            = Set.empty

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 10
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

unify :: ConstraintList -> Maybe Substitution
unify [] = Just Map.empty
unify (x:xs) = case x of 
                    (CError)                        -> Nothing
                    (CEq t1 t2)                     -> if t1 == t2 then unify xs
                                                            else case ((CEq t1 t2), Set.notMember t1 (tvars t2), Set.notMember t2 (tvars t1)) of 
                                                                      ((CEq (TVar i1) t2), True, _)              -> case (unify (applySubToCstrList (Map.fromList [(TVar i1, t2)]) xs)) of  
                                                                                                                        (Just value) -> Just (composeSub value (Map.fromList [(TVar i1, t2)]))
                                                                                                                        _            -> Nothing
                                                                      (CEq t1 (TVar i2), _ , True)               -> case (unify (applySubToCstrList (Map.fromList [(TVar i2, t1)]) xs)) of 
                                                                                                                        (Just value) -> Just (composeSub value (Map.fromList [(TVar i2, t1)]))
                                                                                                                        _            -> Nothing
                                                                      (CEq (TArr t1 t2) (TArr t3 t4), _ , _ )    -> unify (xs ++ [CEq t1 t3 , CEq t2 t4])
                                                                      _                                          -> Nothing

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 11
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

typing :: Expr -> Maybe Type
typing e = do let (t,c) = inferExpr e
              substitution <- unify (toCstrList c)
              return (applySub substitution t)

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Question 12
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

typeInfer :: Expr -> String
typeInfer e = case typing e of 
                   Nothing  -> "Type Error"
                   (Just v) -> show (relabel v)

typ :: Expr -> Maybe (Substitution, Type)
typ e = do let (t,c) = inferExpr e
           substitution <- unify (toCstrList c)
           return (substitution, t)

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Main IO (Question 13)
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
main :: IO ()
main = do
        args <- getArgs
        let filePath = head(args)
        expressions <- readFile filePath
        let stringExpressionsList = lines expressions
        let expressionsList = map read stringExpressionsList 
        mapM_ putStrLn (map typeInfer expressionsList)