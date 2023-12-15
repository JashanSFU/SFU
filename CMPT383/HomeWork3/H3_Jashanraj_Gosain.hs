data List a = Empty | Cons a (List a) deriving (Eq, Ord, Show, Read)
listZip :: List a -> List b -> List (a,b)
listZip Empty _ = Empty
listZip _ Empty = Empty
listZip (Cons x xs) (Cons y ys) = Cons (x,y) (listZip xs ys)

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving ( Ord, Show, Read)
instance Eq a => Eq (Tree a) where 
    EmptyTree == EmptyTree  = True 
    EmptyTree == (Node a l r) = False
    (Node a leftTree1 rightTree1) == (Node b leftTree2 rightTree2 )  =  (a == b) && leftTree1 == leftTree2 && rightTree1 == rightTree2
    _ == _ = False

insert :: Ord a => a -> Tree a -> Tree a 
insert a EmptyTree = Node a (EmptyTree) (EmptyTree)
insert a (Node value leftTree rightTree)
    | a > value = Node value leftTree (insert a rightTree)
    | a < value = Node value (insert (a) (leftTree)) rightTree


data Nat = Zero | Succ Nat deriving (Eq, Ord, Show, Read)
natPlus :: Nat -> Nat -> Nat
natPlus Zero answer = answer
natPlus answer Zero = answer
natPlus (Succ value1) (Succ value2) = Succ (Succ (natPlus value1 value2))

natMult :: Nat -> Nat -> Nat
natMult Zero _ = Zero
natMult _ Zero = Zero
natMult mult1 mult2 = natMultWithPlus mult1 mult2 Zero Zero

natMultWithPlus :: Nat -> Nat -> Nat -> Nat -> Nat
natMultWithPlus _ mult2 answer repeated
    | mult2 == repeated     = answer
natMultWithPlus mult1 mult2 answer repeated = natMultWithPlus mult1 mult2 (natPlus answer mult1) (natPlus repeated (Succ Zero))


data AssocList k v = ALEmpty | ALCons k v (AssocList k v) deriving (Show)

instance Functor (AssocList k) where
 fmap :: (a -> b)-> (AssocList k) a -> (AssocList k) b 
 fmap _ ALEmpty = ALEmpty
 fmap f (ALCons k v functorValue) =  ALCons k (f v) (fmap f functorValue)