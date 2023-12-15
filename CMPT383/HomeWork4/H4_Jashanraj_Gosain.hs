data ErrJst e j = Err e | Jst j deriving (Show)

-- Question 1
instance Functor (ErrJst e) where
 fmap :: (j -> b) -> (ErrJst e j) -> ErrJst e b
 fmap _ (Err e) = Err e
 fmap f (Jst j) = Jst (f j)

-- Question 2
instance Applicative (ErrJst e) where
 pure :: a -> ErrJst e a
 (<*>) :: (ErrJst e (a -> b)) -> (ErrJst e a) -> (ErrJst e b)
 pure = Jst
 (Err e) <*> _ = Err e
 (Jst f) <*> x = fmap f x 

-- Question 3 
instance Monad (ErrJst e) where
 (>>=) :: (ErrJst e a) -> (a -> (ErrJst e b)) -> ErrJst e b
 (Err e) >>= _  = Err e
 (Jst x) >>= f  = f x


-- Question 4
join :: Monad m => m (m a) -> m a
join m = (m >>= id)

-- Question 5
data LTree a = Leaf a | LNode (LTree a) (LTree a) deriving (Show)

instance Foldable (LTree) where
 foldMap :: (Monoid m) => (a -> m) -> LTree a -> m
 foldMap f (Leaf a) = (f a)
 foldMap f (LNode lSubTree rSubTree) = mappend (foldMap f lSubTree) (foldMap f rSubTree )
