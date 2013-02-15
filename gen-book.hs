{-# OPTIONS -fdefer-type-errors #-}
{-# LANGUAGE TypeHoles, FlexibleInstances  #-}

import Control.Monad
import Test.QuickCheck
import Data.List
import Data.List.Split (splitPlaces)
import Data.Char


newtype Phone = Phone String deriving Show
newtype Name = Name String deriving Show
data Person = Person Name [Phone] deriving Show

instance Arbitrary Phone where
    arbitrary = do digits <- sequence . repeat . choose $ (0,9) :: Gen [Int]
                   n <- choose (2,4)
                   gs <- vectorOf n $ choose (2,3) :: Gen [Int]
                   let pp = splitPlaces gs digits
                   return . Phone . concat . intersperse "-" . map (map intToDigit) $ pp



instance Arbitrary (IO Name) where
    arbitrary = promote $ do names <- liftM lines $ readFile "/usr/share/dict/propernames"
                             return $ Name `liftM` elements names

instance Arbitrary (IO Person) where
    arbitrary = do name <- arbitrary :: Gen (IO Name)
                   n <- choose (2,5)
                   phones <- vectorOf n arbitrary
                   return $ liftM (flip Person phones) name


toInsert (Person (Name name) phones) =
    "insert into people values (null, '" ++ name ++ "','" ++ pstr ++ "');"
        where pstr = quote . concat . intersperse ", " $ [ toJson num | Phone num <- phones ]
              toJson num = "{\"number\":" ++ show num
              quote x = "[" ++ x ++ "]"


main = do people <- sample' arbitrary >>= sequence
          putStrLn . unlines $ [ toInsert p | p <- people ]



