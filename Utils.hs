module Utils where

import Data.Char

-----------------------------------------------------------------------------------------------------
------------------------------------- GENERAL UTILITY FUNCTIONS -------------------------------------
-----------------------------------------------------------------------------------------------------

-- Moves the first element of a list from the front to the back
shiftList :: [a] -> [a]
shiftList (c : cs) = cs ++ [c]

-- Drops all elements of a list that do not satisfy a given condition
-- example conditions:
-- drop spaces                 c == ' '
-- drop less than 0            n < 0
-- drop greater than 25        n > 25
dropOnCondition :: (a -> Bool) -> [a] -> [a]
dropOnCondition _ [] = []
dropOnCondition cond (e : es)
  | cond e = dropOnCondition cond es
  | otherwise = e : dropOnCondition cond es

-- Cleanses a Maybe variable into it's contained type, with a given default value in case of Nothing
maybeCleanser :: a -> Maybe a -> a
maybeCleanser _ (Just b) = b
maybeCleanser a Nothing = a

-- Repeats a function that transforms one element of a type a given number of times, with a given input
-- i.e. for repeatFunction f() n x
-- the function f() will be repeated n times on the input x (operates recursively)
repeatFunction :: (a -> a) -> Int -> a -> a
repeatFunction func n a
  -- Guards against negative inputs, and stops if n is 0
  | n <= 0 = a
  | otherwise = repeatFunction func (n - 1) (func a)

-----------------------------------------------------------------------------------------------------
------------------------------------- TYPE CONVERSION FUNCTIONS -------------------------------------
-----------------------------------------------------------------------------------------------------

-- Converts all characters in the alphabet to their numerical representation (shifted to be within 0-25)
-- Converts any non alphabetical characters to -1
charToNum :: Char -> Int
charToNum c
  | isAlpha cUpper = ord cUpper - ord 'A'
  | otherwise = -1
  where
    -- Ensures all characters are capitalised, ensures capital and lowercase letters are encoded as the same number
    cUpper = toUpper c

-- Converts numerical representations of characters back into the character they came from
-- Any non alphabetical characters (outside 0-25) converted to spaces
numToChar :: Int -> Char
numToChar n
  | n >= 0 && n <= 25 = chr (n + ord 'A')
  | otherwise = ' '

-- Converts a String to a list of Ints representing the Characters in the String
-- Drops any non-alphabetical characters (represented as -1, see charToNum)
stringToNumList :: String -> [Int]
stringToNumList s = dropOnCondition (< 0) ([charToNum c | c <- s])

-- Converts a list of Ints to the Characters they represent
numListToString :: [Int] -> String
numListToString ns = [numToChar n | n <- ns]
