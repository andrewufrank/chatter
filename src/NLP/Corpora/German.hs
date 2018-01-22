{-----------------------------------------------------------------------------
--
-- Module       | --  Dependency and other Codes
--
-- | the codes for TinT parser for German
--
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

module  NLP.Corpora.German (module  NLP.Corpora.German
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

import qualified NLP.Types.Tags as NLPtypes
--import      NLP.Corpora.Conll
--import      NLP.Corpora.Conll   as Conll

--type PosTagEng = Conll.Tag   -- renames the ConllTag
--instance CharChains2 PosTagEng Text

data POSTagGerman =   -- copied from http://universaldependencies.org/u/pos/
    START  | -- START tag, used in training.
    END | --END tag, used in training.
    Dollarpoint | --    $.       |   --	0
    Dollaropenbracket | --  $[       |   --	 '
    Dollarcomma  |   --	,
    ADJA       |   --	environs
    ADJD       |   --	I.
    ADV       |   --	que
    APPO       |   --	l'épouse
    APPR       |   --	 --
    APPRART       |   --	 --
    APZR       |   --	avoir
    ART       |   --	DES
    CARD       |   --	XI
    FM       |   --	tous
    ITJ       |   --	oui
    KON       |   --	un
    KOUS       |   --	sous
    NE       |   --	XXII
    NN       |   --	CONCLUSION
    PDAT       |   --	d'analyse
    PDS       |   --	une
    PIAT       |   --	ajouta
    PIDAT       |   --	jeune
    PIS       |   --	aller
    PPER       |   --	du
    PPOSAT       |   --	donner
    PRELS       |   --	qui
    PRF       |   --	café
    PROAV       |   --	d'un
    PTKANT       |   --	avec
    PTKNEG       |   --	net
    PTKVZ       |   --	fort
    PWAV       |   --	dit
    PWS       |   --	mon
    TRUNC       |   --	en
    VAFIN       |   --	C'est
    VAINF       |   --	sein
    VMFIN       |   --	démêlés
    VVFIN       |   --	chrétienne
    VVIMP       |   --	j'
    VVINF       |   --	bien
    VVIZU       |   --	hésitation
    VVPP       |   --	maintenant
    XY       |   --	n
    PTKZU |
    VAPP  |
    KOUI |
    PTKA |
    VMINF |
    VAIMP |
    PRELAT |
    PWAT |
    VMPP |
    PPOSS |
    KOKOM |
    Germanunk  -- other  -- conflicts possible!
        deriving (Read, Show, Ord, Eq, Generic, Enum, Bounded)


instance NLPtypes.POSTags POSTagGerman where
--parseTag :: Text -> PosTag
    parseTag txt = case readTag txt of
                   Left  _ -> NLPtypes.tagUNK
                   Right t -> t

    tagUNK = Germanunk

    tagTerm = showTag

    startTag = START
    endTag = END

    isDt tag = tag `elem` []  -- unknown what is a det here?

instance Arbitrary POSTagGerman where
  arbitrary = elements [minBound ..]
instance Serialize POSTagGerman

readTag :: Text -> ErrOrVal POSTagGerman
--readTag "#" = Right Hash
--readTag "$" = Right Dollar
--readTag "(" = Right Op_Paren
--readTag ")" = Right Cl_Paren
--readTag "''" = Right CloseDQuote
--readTag "``" = Right OpenDQuote
--readTag "," = Right Comma
--readTag "." = Right Term
--readTag ":" = Right Colon
readTag txt =
  let normalized = replaceAll tagTxtPatterns (T.toUpper  txt)
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

showTag :: POSTagGerman -> Text
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

--readTag :: Text -> ErrOrVal POSTagGerman
--readTag txt = maybe2errorP . read . t2s $ txt
--
--maybe2errorP  :: Maybe a -> ErrOrVal a
--maybe2errorP Nothing = Left "readTag POSTagGerman 34232"
--maybe2errorP (Just a) = Right a

readOrErr :: Read a => Text -> Either Text a
readOrErr    t = case (readEither (t2s t)) of
                        Left msg -> Left (s2t msg)
                        Right a -> Right a

--instance CharChains2 POSTagGerman String where
--    show' =  show
--instance CharChains2 POSTagGerman Text where
--    show' =  s2t . show
--
--instance Zeros POSTagGerman where zero = NLPtypes.tagUNK
----type Unk = Conll.Unk



