module BoardTest where

import Board

import Test.HUnit

empty_grid_0_0 = []
empty_grid_1_1 = [[0]]
empty_grid_1_2 = [[0,0]]
empty_grid_2_2 = [[0,0],
                  [0,0]]
empty_grid_3_3 = [[0,0,0],
                  [0,0,0],
                  [0,0,0]]
empty_grid_6_7 = [[0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0]]

test_new_grid_00 = TestCase (assertEqual "new_grid" (new_grid 0 0) empty_grid_0_0)
test_new_grid_11 = TestCase (assertEqual "new_grid" (new_grid 1 1) empty_grid_1_1)
test_new_grid_12 = TestCase (assertEqual "new_grid" (new_grid 1 2) empty_grid_1_2)
test_new_grid_22 = TestCase (assertEqual "new_grid" (new_grid 2 2) empty_grid_2_2)
test_new_grid_33 = TestCase (assertEqual "new_grid" (new_grid 3 3) empty_grid_3_3)
test_new_grid_67 = TestCase (assertEqual "new_grid" (new_grid 6 7) empty_grid_6_7)

mostly_full_grid = [[2,0,0,1,0,2,0],
                    [2,1,2,1,2,1,2],
                    [1,2,2,1,1,2,1],
                    [2,1,1,2,2,1,2],
                    [2,2,1,1,1,2,2],
                    [1,2,1,1,2,1,1]]

test_is_valid_move_col_1 = TestCase (assertBool "valid_move" (is_valid_move mostly_full_grid 1))
test_is_valid_move_col_2 = TestCase (assertBool "valid_move" (is_valid_move mostly_full_grid 2))
test_is_valid_move_col_4 = TestCase (assertBool "valid_move" (is_valid_move mostly_full_grid 4))
test_is_valid_move_col_6 = TestCase (assertBool "valid_move" (is_valid_move mostly_full_grid 6))
test_is_not_valid_move_col_0 = TestCase (assertEqual "valid_move" (is_valid_move mostly_full_grid 0) False)
test_is_not_valid_move_col_3 = TestCase (assertEqual "valid_move" (is_valid_move mostly_full_grid 3) False)
test_is_not_valid_move_col_5 = TestCase (assertEqual "valid_move" (is_valid_move mostly_full_grid 5) False)

grid_move_0_1 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [1,0,0,0,0,0,0]]
grid_move_0_2 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [2,0,0,0,0,0,0],
                 [1,0,0,0,0,0,0]]
grid_move_1_1 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [2,0,0,0,0,0,0],
                 [1,1,0,0,0,0,0]]
grid_move_2_2 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [2,0,0,0,0,0,0],
                 [1,1,2,0,0,0,0]]
grid_move_6_1 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [2,0,0,0,0,0,0],
                 [1,1,2,0,0,0,1]]
grid_move_4_2 = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [2,0,0,0,0,0,0],
                 [1,1,2,0,2,0,1]]

test_apply_move_0_1 = TestCase (assertEqual "apply_move" (apply_move empty_grid_6_7 0 1) grid_move_0_1)
test_apply_move_0_2 = TestCase (assertEqual "apply_move" (apply_move grid_move_0_1 0 2) grid_move_0_2)
test_apply_move_1_1 = TestCase (assertEqual "apply_move" (apply_move grid_move_0_2 1 1) grid_move_1_1)
test_apply_move_2_2 = TestCase (assertEqual "apply_move" (apply_move grid_move_1_1 2 2) grid_move_2_2)
test_apply_move_6_1 = TestCase (assertEqual "apply_move" (apply_move grid_move_2_2 6 1) grid_move_6_1)
test_apply_move_4_2 = TestCase (assertEqual "apply_move" (apply_move grid_move_6_1 4 2) grid_move_4_2)

win_grid = [[0,2,0,0,0,0,0],
            [0,2,0,0,0,0,0],
            [0,2,0,2,0,0,0],
            [0,2,1,1,2,0,0],
            [0,1,2,2,1,2,0],
            [1,2,1,1,1,1,2]]

test_win_col0_p1 = TestCase (assertBool "is_win" (is_win win_grid 0 1))
test_win_col1_p2 = TestCase (assertBool "is_win" (is_win win_grid 1 2))
test_win_col3_p2 = TestCase (assertBool "is_win" (is_win win_grid 3 2))
test_no_win_col1_p1 = TestCase (assertEqual "is_win" (is_win win_grid 1 1) False)
test_no_win_col2_p2 = TestCase (assertEqual "is_win" (is_win win_grid 2 2) False)
test_no_win_col3_p1 = TestCase (assertEqual "is_win" (is_win win_grid 3 1) False)

tests = TestList [TestLabel "testGrid00" test_new_grid_00,
                  TestLabel "testGrid11" test_new_grid_11,
                  TestLabel "testGrid12" test_new_grid_12,
                  TestLabel "testGrid22" test_new_grid_22,
                  TestLabel "testGrid22" test_new_grid_33,
                  TestLabel "testGrid67" test_new_grid_67,
                  TestLabel "testValidMoveCol1" test_is_valid_move_col_1,
                  TestLabel "testValidMoveCol2" test_is_valid_move_col_2,
                  TestLabel "testValidMoveCol4" test_is_valid_move_col_4,
                  TestLabel "testValidMoveCol6" test_is_valid_move_col_6,
                  TestLabel "testInvalidMoveCol0" test_is_not_valid_move_col_0,
                  TestLabel "testInvalidMoveCol3" test_is_not_valid_move_col_3,
                  TestLabel "testInvalidMoveCol5" test_is_not_valid_move_col_5,
                  TestLabel "testApplyMove01" test_apply_move_0_1,
                  TestLabel "testApplyMove02" test_apply_move_0_2,
                  TestLabel "testApplyMove11" test_apply_move_1_1,
                  TestLabel "testApplyMove22" test_apply_move_2_2,
                  TestLabel "testApplyMove61" test_apply_move_6_1,
                  TestLabel "testApplyMove42" test_apply_move_4_2,
                  TestLabel "testWinCol0P1" test_win_col0_p1,
                  TestLabel "testWinCol1P2" test_win_col1_p2,
                  TestLabel "testWinCol3P2" test_win_col3_p2,
                  TestLabel "testNoWinCol1P1" test_no_win_col1_p1,
                  TestLabel "testNoWinCol2P2" test_no_win_col2_p2,
                  TestLabel "testNoWinCol3P1" test_no_win_col3_p1]

main :: IO ()
main = do
    runTestTT tests
    return ()
