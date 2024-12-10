-- Aoc day 3 haskell
-- ghc -o builds/day03 day03.hs && builds/day03
-- day03.exe

import Text.Regex.Posix
import Text.Printf

multRegex = "mul\\([0-9]+,[0-9]+\\)"
instRegex = "(mul\\([0-9]+,[0-9]+\\))|(do\\(\\))|(don't\\(\\))"
doRx      = "do\\(\\)"
dtRx      = "don't\\(\\)"

slice :: Int -> Int -> [Char] -> [Char]
slice a b = (take (b - a)) . (drop a)

-- Used to remove "mul(" and ")" from a string
remMul :: [Char] -> [Char]
remMul str = (drop 4 (init str))

-- Split by a char
wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s = case dropWhile p s of
    "" -> []
    s' -> w : wordsWhen p s''
        where(w, s'') = break p s'

splitByComma = wordsWhen (==',')
multLst = foldl (*) 1
sumLst = foldl (+) 0

-- Filter the dos and dont's keeping the state of the last one
filterDos :: (Bool, [String]) -> String -> (Bool, [String])
filterDos (cond, lst) x 
    | x =~ doRx = (True, lst)
    | x =~ dtRx = (False, lst)
    | cond      = (cond, x : lst)
    | otherwise = (cond, lst)

removeDonts :: [String] -> [String]
removeDonts lst = 
    let (_, result) = foldl filterDos (True, []) lst 
    in reverse result

-- Process the mult string, multiply and add the results
applyMults :: [String] -> Int
applyMults lst = 
    -- Process to list of pairs of numbers
    let pairs = map (splitByComma . remMul) lst
        converted = map (map read) pairs :: [[Int]]

        -- Multiply each
        mults = map multLst converted
    in
        -- Add each
        sumLst mults

main :: IO ()
main = do
    -- Read the input
    input <- readFile "inputs/input03.txt" 

    -- Part 1
    -- Match all the valid "mul(num,num)"
    let matchedMults = getAllTextMatches $ (input =~ multRegex) :: [String]
    
    let addedMults = applyMults matchedMults
    printf "Added multiplications: %d\n" addedMults

    -- Part 2
    -- Match "mul(num,num)", "do()" and "don't()"
    let matchedInst = getAllTextMatches $ (input =~ instRegex) :: [String]

    let filteredDos = removeDonts matchedInst

    let addedFilteredMults = applyMults filteredDos
    printf "Mults with no don't %d\n" addedFilteredMults

