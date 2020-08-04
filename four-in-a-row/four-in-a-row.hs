type Grid = [Row]
type Row = [Int]
type Col = [Int]
type Stone = Int


-- 1. Creating an Empty Grid
new_grid :: Int -> Int -> Grid
new_grid r c = [new_row c | _ <- [1..r]]

new_row :: Int -> Row
new_row c = [0 | _ <- [1..c]]

-- 2. Validating a Move
is_valid_move :: Grid -> Int -> Bool
is_valid_move g c = (get_column g c) !! 0 == 0

-- 3. Setting a Stone
apply_move :: Grid -> Int -> Int -> Grid
apply_move g c p = (replace_value g r c p)
                   where r = bottom_most g 0 c

replace_value :: Grid -> Int -> Int -> Stone -> Grid
replace_value g r c p = take r g ++ [new_row] ++ drop (r + 1) g
                        where new_row = replace_row_value (g !! r) c p

replace_row_value :: Row -> Int -> Stone -> Row
replace_row_value r c p = take c r ++ [p] ++ drop (c+1) r

bottom_most :: Grid -> Int -> Int -> Int
bottom_most g v c = length (takeWhile (\x -> x == v) col) - 1
                    where col = get_column g c

-- common functions
get_column :: Grid -> Int -> Col
get_column g c = [row !! c | row <- g]

-- True if the first list is contained in the second list, False otheriwse
contained :: Eq a => [a] -> [a] -> Bool
contained [] []                     = True
contained [] ys                     = True
contained xs []                     = False
contained (x:xs) (y:ys) | x == y    = and [x == y | (x,y) <- zip xs ys]
                                      && length xs <= length ys
                                      || contained (x:xs) ys
                        | otherwise = contained (x:xs) ys
