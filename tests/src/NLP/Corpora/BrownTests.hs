module NLP.Corpora.BrownTests where

import Test.QuickCheck.Instances ()
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.QuickCheck (testProperty)

import qualified NLP.Corpora.Brown as B
import NLP.Types

tests :: TestTree
tests = testGroup "NLP.Corpora.Brown"
        [ testProperty "Brown POS Tags round-trip" prop_tagsRoundTrip
        ]

prop_tagsRoundTrip :: B.POStag -> Bool
prop_tagsRoundTrip tag = tag == (parseTag . fromTag) tag

