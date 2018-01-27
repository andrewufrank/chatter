{-----------------------------------------------------------------------------
--
-- Module       | --  Dependency and other Codes
--
-- | the codes for French parser for French
-- model is http://nlp.stanford.edu/software/stanford-french-corenlp-2017-06-09-models.jar
-- pos tageset name is
-- from http://www.llf.cnrs.fr/Gens/Abeille/French-Treebank-fr.php
http://www.llf.cnrs.fr/sites/sandbox.linguist.univ-paris-diderot.fr/files/statiques/french_treebank/guide-morpho-synt.02.pdf
-- model is http://nlp.stanford.edu/software/stanford-french-corenlp-2017-06-09-models.jar
with set to -serverProperties StanfordCoreNLP-french.properties
-----------------------------------------------------------------------------}
--{-# OPTIONS_GHC -F -pgmF htfpp #-}
{-# LANGUAGE        MultiParamTypeClasses
       , ScopedTypeVariables
        , FlexibleContexts
    , OverloadedStrings
        , TypeSynonymInstances
        , FlexibleInstances
        , DeriveAnyClass
        , DeriveGeneric
        #-}

module NLP.Corpora.French (module NLP.Corpora.French
--        , module NLP.Corpora.Conll
--        , ErrOrVal (..)
        )
         where

import GHC.Generics
import Data.Serialize (Serialize)
import qualified Data.Text as T
import Data.Text (Text)
import Data.Utilities
--import           Test.Framework
import Test.QuickCheck.Arbitrary (Arbitrary(..))
import Test.QuickCheck.Gen (elements)

--import Uniform.Zero
--import Uniform.Strings
--import Uniform.Error
import Data.Text   as T (replace)
import Text.Read (readEither)
--import qualified NLP.Corpora.Conll      as Conll

--import qualified NLP.Types.Tags as NLPtypes
import  NLP.Types.Tags as NLPtypes
--import      NLP.Corpora.Conll
--import      NLP.Corpora.Conll   as Conll

--type POSTagEng = Conll.Tag   -- renames the ConllTag
--instance CharChains2 POSTagEng Text

data POStagFrench =   -- copied from http://universaldependencies.org/u/pos/
    START  | -- START tag, used in training.
    END | --END tag, used in training.
    DET |
    N |
    P |
    NPP |
    PUNC |
    ET |
    NC |
    ADJ |
    ADV |  -- found in output, example peu (UD code set)
    CLS |
    V |
    VPR |
    VINF |
    CLR |
    VPP |
    PRO |
    CC |
    CS |
    PROREL |
    C |
    PREF |
    CLO |
    I |
    ADVWH |
    VIMP |
    DETWH |
    ADJWH |
    CL |
    PROWH |
    VS |
    Frenchunk  -- other  -- conflicts possible!
        deriving (Read, Show, Ord, Eq, Generic, Enum, Bounded)


instance NLPtypes.POStags POStagFrench where
--parseTag :: Text -> POSTag
    parseTag txt = case readTag txt of
                   Left  _ -> NLPtypes.tagUNK
                   Right t -> t

    tagUNK = Frenchunk

    tagTerm = showTag

    startTag = START
    endTag = END

    isDt tag = tag `elem` []  -- unknown what is a det here?

instance Arbitrary POStagFrench where
  arbitrary = elements [minBound ..]
instance Serialize POStagFrench

readTag :: Text -> ErrOrVal POStagFrench
--readTag "#" = Right Hash
--readTag "$" = Right Dollar
--readTag "(" = Right Op_Paren
--readTag ")" = Right Cl_Paren
--readTag "''" = Right CloseDQuote
--readTag "``" = Right OpenDQuote
--readTag "," = Right Comma
--readTag "." = Right Point
--readTag "." = Right Term
--readTag ":" = Right Colon
--readTag "[" = Right Openbracket

readTag txt =
  let normalized = replaceAll tagTxtPatterns (T.toUpper txt)
  in  (readOrErr  normalized)

-- | Order matters here: The patterns are replaced in reverse order
-- when generating tags, and in top-to-bottom when generating tags.
tagTxtPatterns :: [(Text, Text)]
tagTxtPatterns = [ ("$", "Dollar")    -- because dollar is always in first position, capitalize
                                        -- better solution is probably to use toUpper
                                        -- and define DOLLARPOINT etc.
                   , ("[", "openbracket")
                   , (",", "comma")
                   , (".", "point")
                 ]

reversePatterns :: [(Text, Text)]
reversePatterns = map (\(x,y) -> (y,x)) tagTxtPatterns

showTag :: POStagFrench -> Text
--showTag Hash = "#"
--showTag Op_Paren = "("
--showTag Cl_Paren = ")"
--showTag CloseDQuote = "''"
--showTag OpenDQuote = "``"
--showTag Dollar = "$"
--showTag Comma = ","
--showTag Term = "."
--showTag Colon = ":"
showTag tag = replaceAll reversePatterns (s2t $ show tag)

replaceAll :: [(Text, Text)] -> (Text -> Text)
replaceAll patterns = foldl (.) id (map (uncurry  T.replace) patterns)

--readTag :: Text -> ErrOrVal POStagFrench
--readTag txt = maybe2errorP . read . t2s $ txt
--
--maybe2errorP  :: Maybe a -> ErrOrVal a
--maybe2errorP Nothing = Left "readTag POStagFrench 34232"
--maybe2errorP (Just a) = Right a

readOrErr :: Read a => Text -> Either Text a
readOrErr    t = case (readEither (t2s t)) of
                        Left msg -> Left (s2t msg)
                        Right a -> Right a

--instance CharChains2 POStagFrench String where
--    show' =  show
--instance CharChains2 POStagFrench Text where
--    show' =  s2t . show
--
--instance Zeros POStagFrench where zero = NLPtypes.tagUNK
----type Unk = Conll.Unk

--test_french_tag1 :: IO ()
--test_french_tag1 = assertEqual (Dollaropenbracket::POStagFrench) (parseTag "$["::POStagFrench)
--test_french_tag2 :: IO ()
--test_french_tag2 = assertEqual (Dollarpoint::POStagFrench) (parseTag "$."::POStagFrench)
--test_french_tag3 :: IO ()
--test_french_tag3 = assertEqual (Dollarcomma::POStagFrench) (parseTag "$,"::POStagFrench)
--test_french_tag4 :: IO ()
--test_french_tag4 = assertEqual (VVINF::POStagFrench) (parseTag "VVINF"::POStagFrench)
--
--test_french_tagR :: IO ()
--test_french_tagR = assertEqual ("Dollaropenbracket"::Text) (replaceAll tagTxtPatterns (toUpper'   "$[")::Text)
