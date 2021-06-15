module Enigma where

import Data.Bifunctor
import Data.List
import Plugboard
import Utils

data Rotor
  = I
  | II
  | III
  | IV
  | V
  deriving (Show)

data Reflector
  = B
  | C
  deriving (Show)

type TurnoverChar = Char

type RotorDetails = (String, TurnoverChar)

alphabet :: String
alphabet = ['A' .. 'Z']

-- Gives the encoding of each Rotor
rotorEncoding :: Rotor -> RotorDetails
rotorEncoding I = ("EKMFLGDQVZNTOWYHXUSPAIBRCJ", 'Q')
rotorEncoding II = ("AJDKSIRUXBLHWTMCQGZNPYFVOE", 'E')
rotorEncoding III = ("BDFHJLCPRTXVZNYEIWGAKMUSQO", 'V')
rotorEncoding IV = ("ESOVPZJAYQUIRHXLNFTGKDCMWB", 'J')
rotorEncoding V = ("VZBRGITYUPSDNHLXAWMJQOFECK", 'Z')

-- Gives the encoding of each Reflector
reflectorEncoding :: Reflector -> String
reflectorEncoding B = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
reflectorEncoding C = "FVPJIAOYEDRZXWGCTKUQSBNMHL"

-----------------------------------------------------------------------------------------------------
------------------------------------- ENIGMA UTILITY FUNCTIONS --------------------------------------
-----------------------------------------------------------------------------------------------------

-- Rotates a rotor's encoding, moving it by one position
rotateEncoding :: RotorDetails -> RotorDetails
rotateEncoding = first shiftList

-- Checks if a Rotor is on it's turnover character, indicating whether or not the next wheel should be turned
checkTurnover :: RotorDetails -> Bool
checkTurnover ro = head (fst ro) == snd ro

-----------------------------------------------------------------------------------------------------
------------------------------------- ENIGMA ENCODING FUNCTIONS -------------------------------------
-----------------------------------------------------------------------------------------------------

-- Converts a characters numerical representation to that of the character in it's position in an encoding String
-- Example:
-- 'A' represented as 0
-- given the encoding of Rotor I "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
-- take element at position 0
-- 'A' encoded as 'E'
-- convert to number, 'E' becomes 4
encodeCharNum :: Int -> String -> Int
encodeCharNum n encoding = charToNum $ encoding !! n

-- Inverse of encodeCharNum, gets the number that would encode into the given number from the encoding String
-- Maybe cleanser used as earlier steps in program ensure no unexpected values appear
-- Example:
-- 4 is input, representing 'E'
-- given the encoding of Rotor I "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
-- 'E' is found in position 0
-- 0 represents 'A'
reverseEncodeCharNum :: Int -> String -> Int
reverseEncodeCharNum n encoding = maybeCleanser 0 maybeCharPosition
  where
    character = numToChar n
    maybeCharPosition = elemIndex character encoding

------------------------------------------------------------------------------------------------------
------------------------------------------ ENIGMA FUNCTIONS ------------------------------------------
------------------------------------------------------------------------------------------------------

-- Initilises the Enigma Machine and it's settings
-- Converts the input String to a list of Ints as used by the rest of the program
enigmaMachine :: String -> Rotor -> Rotor -> Rotor -> Int -> Int -> Int -> Reflector -> Plugs -> String
enigmaMachine s ro1 ro2 ro3 ro1Start ro2Start ro3Start ref plugs =
  plugboard
    ( numListToString $
        enigmaRun numEncodedString ro1Details ro2Details ro3Details refDetails
    )
    plugs
  where
    -- Gets the initial encoding of the rotors
    ro1Init = rotorEncoding ro1
    ro2Init = rotorEncoding ro2
    ro3Init = rotorEncoding ro3
    -- Sets the initial position of each rotor
    ro1Details = repeatFunction rotateEncoding ro1Start ro1Init
    ro2Details = repeatFunction rotateEncoding ro2Start ro2Init
    ro3Details = repeatFunction rotateEncoding ro3Start ro3Init
    -- Gets the encoding of the reflector
    refDetails = reflectorEncoding ref
    numEncodedString = stringToNumList $ plugboard s plugs

-- Runs the Enigma machine on all elements of the input list
enigmaRun :: [Int] -> RotorDetails -> RotorDetails -> RotorDetails -> String -> [Int]
-- case for empty list
enigmaRun [] _ _ _ _ = []
-- case for non-empty list
enigmaRun (n : ns) ro1 ro2 ro3 ref
  -- When both the 2nd and 3rd rotor need to be turned gives updated 1st, 2nd and 3rd rotors
  | turnRo3 && turnRo2 =
    -- encodes a single element
    enigmaSingleChar n newRo1 newRo2 newRo3 ref :
    -- runs enigma on all remaining elements
    enigmaRun ns newRo1 newRo2 newRo3 ref
  -- When 2nd rotor needs to be turned gives updated 1st and 2nd rotors, and old 3rd rotor
  | turnRo2 =
    enigmaSingleChar n newRo1 newRo2 ro3 ref :
    enigmaRun ns newRo1 newRo2 ro3 ref
  -- When no other rotors need updating simply gives updated 1st rotor, with old 2nd and 3rd rotors
  | otherwise =
    enigmaSingleChar n newRo1 ro2 ro3 ref :
    enigmaRun ns newRo1 ro2 ro3 ref
  where
    -- gives the updated rotor details for when they turn
    newRo1 = rotateEncoding ro1
    newRo2 = rotateEncoding ro2
    newRo3 = rotateEncoding ro3
    -- gives whether or not the 2nd and 3rd rotors should turn
    turnRo2 = checkTurnover newRo1
    turnRo3 = checkTurnover newRo2

-- encodes a single element of the list using the current rotor settings
enigmaSingleChar :: Int -> RotorDetails -> RotorDetails -> RotorDetails -> String -> Int
enigmaSingleChar n (ro1, _) (ro2, _) (ro3, _) ref = backRo1
  where
    -- encodes forward through the rotors
    passRo1 = encodeCharNum n ro1
    passRo2 = encodeCharNum passRo1 ro2
    passRo3 = encodeCharNum passRo2 ro3
    -- reflects the forward passed characters
    reflected = encodeCharNum passRo3 ref
    -- encodes beackwards through the rotors
    backRo3 = reverseEncodeCharNum reflected ro3
    backRo2 = reverseEncodeCharNum backRo3 ro2
    backRo1 = reverseEncodeCharNum backRo2 ro1
