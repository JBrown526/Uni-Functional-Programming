module Plugboard where

import Data.Char

type Plugs = [(Char, Char)]

-- If an element matches with an element in the pair it is replaced with the other element of the pair
flipElemIfInPair :: Eq a => a -> (a, a) -> a
flipElemIfInPair a (x, y)
  | a == x = y
  | a == y = x
  | otherwise = a

-- flipElemIfInPair over a list of pairs
flipElemIfInPairs :: Eq a => a -> [(a, a)] -> a
flipElemIfInPairs a [] = a
flipElemIfInPairs a (p : ps)
  | flipElemIfInPair a p /= original = flipElemIfInPair a p
  | otherwise = flipElemIfInPairs a ps
  where
    original = a

-- flipElemIfInPairs on a list input
flipListElemsIfInPairs :: Eq a => [a] -> [(a, a)] -> [a]
flipListElemsIfInPairs as ps = [flipElemIfInPairs a ps | a <- as]

-- Flips the characters in a String where necessary according to the plugs provided
plugboard :: String -> Plugs -> String
plugboard s p = flipListElemsIfInPairs sUpper pUpper
  where
    sUpper = [toUpper c | c <- s]
    pUpper = capitalisePlugs p

-- Ensures the characters in the plugs are capitalised
capitalisePlugs :: Plugs -> Plugs
capitalisePlugs ps = [(toUpper a, toUpper b) | (a, b) <- ps]
