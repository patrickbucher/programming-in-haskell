import Data.Char

let2int :: Char -> Int
let2int c = ord c - ord 'a'
-- TODO: isLower: 'a', isUpper: 'A'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)
-- TODO: check if chr n in 'a'..'z' or 'A'..'Z'

shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` 26)
          | otherwise = c
-- TODO: isLower c or isUpper c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x <- ['a'..'z']] where n = lowers xs
-- TODO: convert xs to lower before counting

count :: Char -> String -> Int
count x xs = sum [1 | x' <- xs, x' == x]

lowers :: String -> Int
lowers xs = sum [1 | x <- xs, isLower x]

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

crack :: String -> String
crack xs = encode (-factor) xs
           where
               factor = head (positions (minimum chitab) chitab)
               chitab = [chisqr (rotate n table') table | n <- [0..25]]
               table' = freqs xs
-- TODO: convert table' to lower first
