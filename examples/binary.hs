type Bit = Int

bin2int :: [Bit] -> Int
bin2int bits = sum [w*b | (w,b) <- zip weights bits']
               where weights = iterate (*2) 1
                     bits' = reverse bits

b2i :: [Bit] -> Int
b2i bs = b2i' (reverse bs)
b2i' = foldr (\x y -> x + 2*y) 0
