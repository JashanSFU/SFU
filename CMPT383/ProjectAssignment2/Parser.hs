module Parser (module Control.Applicative, module Data.Char, module Parser) where 

import Control.Applicative
import Data.Char

-----------------------------------------------------------------------
newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) input = p input

item :: Parser Char
item = P (\input -> case input of
        [] -> []
        (x:xs) -> [(x, xs)])
-----------------------------------------------------------------------

instance Functor Parser where
 -- fmap :: (a -> b) -> Parser a -> Parser b
 fmap f p = P (\input -> case parse p input of
                [] -> []
                [(v,out)] -> [(f v, out)])

instance Applicative Parser where
 -- pure :: a -> Parser a
 pure v = P (\input -> [(v, input)])
 -- <*> :: Parser (a -> b) -> Parser a -> Parser b
 pf <*> px = P (\input -> case parse pf input of
                [] -> []
                [(f,out)] -> parse (fmap f px) out)

instance Monad Parser where
 -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
 p >>= f = P (\input -> case parse p input of
                [] -> []
                [(v,out)] -> parse (f v) out)

instance Alternative Parser where
 -- empty :: Parser a
 empty = P (\input -> [])
 -- (<|>) :: Parser a -> Parser a -> Parser a
 p <|> q = P (\input -> case parse p input of
                [] -> parse q input
                [(v,out)] -> [(v,out)])

