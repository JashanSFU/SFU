-- Question 1
fib :: Int -> Int 
fib 0 = 0 
fib 1 = 1 
fib x = fib(x-1) + fib(x-2)

-- Question 2
listReverse :: [a] -> [a]
listReverse [] = []
listReverse (x : xs) = listReverse(xs) ++ [x]


-- Question 3
listAdd :: [Int] -> [Int] -> [Int]
listAdd [] [] = [] 
listAdd [] (y : ys) = y : listAdd [] ys
listAdd (x : xs) [] = x : listAdd xs []
listAdd (x : xs) (y : ys) =  (x + y) : listAdd xs ys


-- Question 4
inList :: Eq a => [a] -> a -> Bool
inList [] _ = False
inList ( x : xs ) y 
    | x == y    = True 
    | otherwise = inList xs y


-- Question 5
sumTailRec :: Num a => [a] -> a
sumTailRec [] = 0 
sumTailRec listOfNumbers = sumTailRecAux listOfNumbers 0

sumTailRecAux :: Num a => [a] -> a -> a 
sumTailRecAux [] sum = sum
sumTailRecAux ( x : xs ) sum = sumTailRecAux (xs) ( x + sum )