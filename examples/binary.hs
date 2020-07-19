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
encode = concat . map (make8 . int2bin . ord)
-- TODO: add parity bit (1 for odd number of ones, 0 otherwise)

chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8
-- TODO: check and discard parity bit

transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id
