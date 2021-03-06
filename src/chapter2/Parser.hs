module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)

import qualified Text.Parsec.Expr as Ex
import qualified Text.Parsec.Token as Tok

import Lexer
import Syntax

binary s f assoc = Ex.Infix (reservedOp s >> return (BinOp f)) assoc

table = [[binary "*" Times Ex.AssocLeft,
          binary "/" Divide Ex.AssocLeft]
        ,[binary "+" Plus Ex.AssocLeft,
          binary "-" Minus Ex.AssocLeft]]

int :: Parser Expr
int = do
  num <- Tok.integer
  return $ Float (fromInteger num)

floating :: Parser Expr
floating = do
  num <- Tok.float
  return $ Float num

expr :: Parser Expr
expr = buildExpressionParser table 

variable :: Parser Expr

function :: Parser Expr

extern :: Parser Expr

call :: Parser Expr

factor :: Parser Expr

defn :: Parser Expr

contents :: Parser a -> Parser a

toplevel :: Parser [Expr]

parseExpr :: String -> Either ParseError Expr
parseExpr s = parse (contents expr) "<stdin>" s

parseToplevel :: String -> Either ParseError [Expr]
parseToplevel s = parse (contents toplevel) "<stdin>" s
