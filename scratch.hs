import Data.Char

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m)

freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x <- ['a'..'z']] where n = lowers xs

count :: Char -> String -> Int
count x xs = sum [1 | x' <- xs, x' == x]

lowers :: String -> Int
lowers xs = sum [1 | x <- xs, isLower x]

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs
