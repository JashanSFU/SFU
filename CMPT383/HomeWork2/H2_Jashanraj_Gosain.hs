-- Question 1 
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl _ x [] = x
myFoldl f x (y: ys) = myFoldl f (f (x) (y)) ys

--Question 2 
myFoldr :: (b -> a -> a) -> a -> [b] -> a
myFoldr _ x [] = x
myFoldr f x (y: ys) = f (y) (myFoldr f x ys)

--Question 3
alternativeMap :: (a -> b) -> (a -> b) -> [a] -> [b]
alternativeMap _ _ [] = []
alternativeMap f1 f2 (x: xs) = f1(x) : alternativefunction f1 f2 xs

alternativefunction :: (a->b) -> (a -> b) -> [a] -> [b]
alternativefunction _ _ [] = []
alternativefunction f1 f2 (x: xs) = f2(x) : alternativeMap f1 f2 xs

--Question 4 
myLength :: [a] -> Int
myLength list = foldr (\ _ x -> x + 1) 0 list

--Question 5
myFilter :: (a-> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter filter list = foldl (\ acc x -> if filter(x) then acc ++ [x] else acc) [] list 

--Question 6
sumsqeven :: [Int] -> Int
sumsqeven =   sum . map (^2) . filter (even)

--foldl (\ acc value -> if even value  then (value*value) + acc else acc) 0