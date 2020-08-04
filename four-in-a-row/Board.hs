module Board (Grid, Row, Col, Stone,
              new_grid, is_valid_move, apply_move, is_win) where

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
                   where
                     r = bottom_most g 0 c

replace_value :: Grid -> Int -> Int -> Stone -> Grid
replace_value g r c p = take r g ++ [new_row] ++ drop (r + 1) g
                        where
                          new_row = replace_row_value (g !! r) c p

replace_row_value :: Row -> Int -> Stone -> Row
replace_row_value r c p = take c r ++ [p] ++ drop (c+1) r

bottom_most :: Grid -> Int -> Int -> Int
bottom_most g v c = length (takeWhile (\x -> x == v) col) - 1
                    where
                      col = get_column g c

-- 4. Detecting a Win
is_win :: Grid -> Int -> Int -> Stone -> Bool
is_win g r c p = horizontal_win g r p ||
                 vertical_win g c p ||
                 diagonal_win g r c p

horizontal_win :: Grid -> Int -> Stone -> Bool
horizontal_win g r p = contained fiar (g !! r)
                       where
                         fiar = [p | _ <- [1..4]]

vertical_win :: Grid -> Int -> Stone -> Bool
vertical_win g c p = contained fiar (get_column g c)
                     where
                       fiar = [p | _ <- [1..4]]

diagonal_win :: Grid -> Int -> Int -> Stone -> Bool
diagonal_win g r c p = contained fiar (diag_asc g r c) ||
                       contained fiar (diag_desc g r c)
                       where
                         fiar = [p | _ <- [1..4]]

diag_asc :: Grid -> Int -> Int -> [Int]
diag_asc g r c = [g !! i !! j | (i,j) <- zip (reverse [0..max_row]) [min_col..cols-1]]
                 where
                   max_row = r + offset
                   min_col = c - offset
                   offset  = min (min (rows - r - 1) (cols - c - 1)) 0
                   rows    = length g
                   cols    = length (g !! 0)

diag_desc :: Grid -> Int -> Int -> [Int]
diag_desc g r c = [g !! i !! j | (i,j) <- zip [min_row..rows-1] [min_col..cols-1]]
                  where
                    min_row = r - offset
                    min_col = c - offset
                    offset  = min r c
                    rows    = length g
                    cols    = length (g !! 0)

-- 5. Formatting the Grid
fmt_grid :: Grid -> String
fmt_grid g = flatten [fmt_row r | r <- g]

fmt_row :: Row -> String
fmt_row r = [fmt_stone s | s <- r] ++ ['\n']

fmt_stone :: Int -> Char
fmt_stone 0 = '-'
fmt_stone 1 = 'x'
fmt_stone 2 = 'o'

-- common functions
get_column :: Grid -> Int -> Col
get_column g c = [row !! c | row <- g]

flatten :: [[Char]] -> [Char]
flatten []       = []
flatten (cs:css) = [c | c <- cs] ++ flatten css

contained :: Eq a => [a] -> [a] -> Bool
contained [] []                     = True
contained [] ys                     = True
contained xs []                     = False
contained (x:xs) (y:ys) | x == y    = and [x == y | (x,y) <- zip xs ys]
                                      && length xs <= length ys
                                      || contained (x:xs) ys
                        | otherwise = contained (x:xs) ys
