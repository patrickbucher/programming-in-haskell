import Data.Char

-- first change: lower and upper case
let2int :: Char -> Int
let2int c | isLower c = ord c - ord 'a' + 26
          | isUpper c = ord c - ord 'A'
          | otherwise = ord c

-- second change: lower and upper case
int2let :: Int -> Char
int2let n | n >= 0 && n < 26 = chr (ord 'A' + n)
          | n >= 26 && n < 52 = chr (ord 'a' + n - 26)
          | otherwise = chr n

-- third change: lower and upper case
shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n - 26) `mod` 26 + 26)
          | isUpper c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

--  third change: lowers becomes alphas
alphas :: String -> Int
alphas xs = sum [1 | x <- xs, isLower x || isUpper x]

-- fourth change: toLowerString function
toLowerString :: [Char] -> [Char]
toLowerString xs = [toLower x | x <- xs]

-- fifth change: convert to lower case for counting
freqs :: String -> [Float]
freqs xs = [percent (count x (toLowerString xs)) n | x <- ['a'..'z']] where n = alphas xs

count :: Char -> String -> Int
count x xs = sum [1 | x' <- xs, x' == x]

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4,
         6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

table' :: [Float]
table' = freqs (encode 8 "there are a lot of programming languages out there")

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..], x == x']

-- sixth change: convert xs to lower case for frequency calculation
crack :: String -> String
crack xs = encode (-factor) xs
           where
               factor = head (positions (minimum chitab) chitab)
               chitab = [chisqr (rotate n table') table | n <- [0..25]]
               table' = freqs (toLowerString xs)
