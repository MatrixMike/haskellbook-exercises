{-# OPTIONS_GHC -fwarn-missing-signatures #-}
--module Chp3Ex where

addBang :: String -> String
addBang str = str ++ "!"

getFifth :: [a] -> a
getFifth str = str !! 4

dropNine :: [a] -> [a]
dropNine = drop 9

thirdLetter :: [a] -> a
thirdLetter str = str !! 2

letterIndex :: Int -> Char
letterIndex x = "Curry is awesome!" !! x

rvrs :: [a] -> [a]
rvrs str = awesome ++ is ++ curry
  where
    curry = take 5 str
    is = take 4 (drop 5 str)
    awesome = drop 9 str

main :: IO ()
main = do
--    print $ str
    print $ rvrs "Curry is awesome!"
    print $ rvrs "Some other text"
    print "end"
    
