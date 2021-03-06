import Data.Char

type Bit = Int

bin2int :: [Bit] -> Int
bin2int bits = sum [w*b | (w,b) <- zip weights bits']
               where weights = iterate (*2) 1
                     bits' = reverse bits

b2i :: [Bit] -> Int
b2i bs = b2i' (reverse bs)
b2i' = foldr (\x y -> x + 2*y) 0

int2bin :: Int -> [Bit]
int2bin n = reverse (int2bin' n)
int2bin' 0 = []
int2bin' n = n `mod` 2 : int2bin' (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = reverse (take 8 ((reverse bits) ++ repeat 0))

encode :: String -> [Bit]
encode = concat . map (add_parity . make8 . int2bin . ord)

add_parity :: [Bit] -> [Bit]
add_parity xs = [x | x <- xs] ++ [checksum xs]

checksum :: [Bit] -> Bit
checksum xs | (count 1 xs) `mod` 2 == 0 = 0
            | otherwise                 = 1

count :: Bit -> [Bit] -> Int
count x xs = sum [1 | y <- xs, y == x]

chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

chop9 :: [Bit] -> [[Bit]]
chop9 [] = []
chop9 bits = take 9 bits : chop9 (drop 9 bits)

decode :: [Bit] -> String
decode = decode_bytes . chop9

decode_bytes :: [[Bit]] -> String
decode_bytes = map (chr . bin2int . take 8) . filter (check_parity)

check_parity :: [Bit] -> Bool
check_parity xs = checksum (take 8 xs) == head (drop 8 xs)

transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id

faulty_transmit :: String -> String
faulty_transmit = decode . faulty_channel . encode

faulty_channel :: [Bit] -> [Bit]
faulty_channel xs = tail xs
