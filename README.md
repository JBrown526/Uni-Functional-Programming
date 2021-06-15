Enigma machine programmed in Haskell from my functional programming coursework

# Program Summary:
This program simulates the operation of one of the Enigma Machines used by the Germans in WWII, specifically using the reflectors and rotor encodings from the Enigma M3 device.

The encoding part of the device can be broken into 3 main components, the plugboard, the rotors and the reflector, the purposes of which are as follows:

## Plugboard:
The plugboard serves to switch a pair of letters both before and after it has been through the rest of the machine. For instance, if the the plugboard had 'A' and 'X' connected, then when an operator entered 'A' it would be changed to an 'X' before moving to the rotors and vice versa. Once it has been encoded by rotors and reflector, it will again pass through the plugboard before the resultant character is displayed to the operator.

## Rotors:
The rotors are the primary form of encoding, and in the M3 Enigma there were 3 in use at any one time, out of a possible 5. The rotors work by creating a "pairing" of characters, where one side will take a character, and proceed to encode it as a different character. For instance, rotor I has the encoding pattern "EKMFLGDQVZNTOWYHXUSPAIBRCJ". This means that it will encode an 'A' as an 'E', a 'B' as a 'K' and so on.

After passing through the reflector, a letter will be encoded in reverse, such that an 'E' would become an 'A', and a 'K' would become a 'B'.

What gives the rotors their name, and helped make the Enigma Machine so difficult to crack, is that after each character, some of the rotors would turn, changing the bindings, so the encoding would change from "EKMFLGDQVZNTOWYHXUSPAIBRCJ" to "KMFLGDQVZNTOWYHXUSPAIBRCJE", with the characters being shifted to the 'left'.

The first rotor will always turn before a new character is entered, while the second and third will turn only when the rotor before them reaches its "turnover character", upon reaching this character it will cause the next rotor to turn 1 position. Essentially (on average), rotor 1 will turn on each character, rotor 2 will turn after 26 turns of rotor 1, and rotor 3 will turn after 26 turns of rotor 2, and 676 turns of rotor 1.

## Reflector:
The reflector is what allows for the Enigma Machine to decrypt a message encrypted by another Enigma machine. For the M3 Enigma, there are 2 possible reflectors. They work much the same way as the plugboard, however instead of being a select few letters which are swapped with each other, it is every letter.

# Running Instructions
To run the program, enter into it's parent directory, and run 'GHCI Enigma.hs' This should compile all 3 modules (Plugboard, Utils and Enigma).

Then call the function 'enigmaMachine' which takes the following 9 arguments:

The String to be encrypted
The first rotor (choose from: I, II, III, IV, V)
The second rotor (as above)
The third rotor (as above)
The position of the first rotor (Any integer can be entered, recommend sticking to 0-25. Negative numbers will be considered to be 0, and numbers greater than 25 will simply loop back around)
The position of the second rotor (as above)
The position of the third rotor (as above)
The reflector to use (choose from: B, C)
A list of character pairs to be used by the plugboard (a-z, characters can be upper or lower case. To ensure the Machine operates correctly, do not enter the same character more than once. There are no guards against this in the program)
Some example function calls are:

enigmaMachine "Hello, World!" I II III 0 0 0 B []
Gives "QHHHQRPVBN"
enigmaMachine "QHHHQRPVBN" I II III 0 0 0 B []
Gives "HELLOWORLD"
note how passing the result of an encryption passed through an Enigma machine with the same settings decrypts to give the original message
enigmaMachine "Hello, World!" III V II 0 0 0 B []
Gives "JAWFTANGMU"
note how changing the code wheels gives a completely different answer with the same input
enigmaMachine "Hello, World!" I II III 7 3 23 B []
Gives "BDXUWCEKEK"
note how changing the starting positions of the code wheels gives a completely different answer
enigmaMachine "Hello, World!" I II III 0 0 0 C []
Gives "VOVZFPHBIO"
note how changing the reflector gives a completely different answer
enigmaMachine "Hello, World!" I II III 0 0 0 B [('h', 'z')]
Gives "MZZZQRPVBN"
note how the characters that began as 'h' have changed to a completel different character, and the characters that were encoded as 'h' are now encoded as 'z'
To verify the machine is working as intended, you can input with any given settings, and if you pass the output back into the machine (with the same settings), it should give you the input, albeit without any fully capitalised, and without punctuation or spaces.

# Interesting and challenging aspects of the project
Higher order functions were used a few times, in the Utils.hs file. These allowed for a generalised function that could drop any element that satisfied a condition in a list (line 18 - dropOnCondition), and a function that allowed the repeating of another function that would transform a variable of any type a given number of times recursively.

The Plugboard.hs file is almost entirely generalised, and has functions for swapping a character if it's in a pair, swapping a character if it's in a list of pairs, and swapping each character in a string should they appear in a list of pairs. I then made non-generalised functions specific for my use case, as it enhanced readability for when they were needed in the rest of the program.

Recursion is used in the core loop of the enigma machine's operation (Enigma.hs - line 107 - enigmaRun), and allows for the rotors to be turned.
