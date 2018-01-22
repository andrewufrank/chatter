{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Data.Utilities

-- a collection of utilities used in construction of tags

where

import qualified Data.Text as T
import Data.Text (Text)
import qualified         Data.Char      as S          (isSpace, isLower, toLower, toUpper)

type ErrOrVal a = Either Text a
-- ^ a type for recording errors as text

s2t :: String -> Text
-- ^ String to Text (invertable)
s2t = T.pack

t2s :: Text -> String
-- ^ String to Text (invertable)
t2s = T.unpack

--toUpper' :: Text -> Text
--toUpper' = map T.toUpper
-- -- ^ convert all char to uppercase

toUpperStart :: Text -> Text
-- ^ convert the first character to Uppercase - for  PosTags in Spanish
toUpperStart t = (S.toUpper . T.head $ t ) `T.cons` (T.tail t)
