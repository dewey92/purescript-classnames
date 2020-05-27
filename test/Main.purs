module Test.Main where

import Prelude

import ClassNames (classNames, (^))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "purescript-classnames" do
    it "generetas classes for strings, arrays, maybes, and records" do
      let record = { key1: true, key2: false }
      let cxs = classNames ("str" ^ Just "maybe" ^ (Nothing :: Maybe String) ^ ["arr1", "arr2"] ^ record)
      cxs `shouldEqual` "str maybe arr1 arr2 key1"

    it "resolves nested classnames" do
      let cxs = classNames (
          [Just "maybe1", Just "maybe2"]
        ^ Just (Just "maybe3")
        ^ Just ["arr1", "arr2"]
        ^ [["arr3"], ["arr4", "arr5"]]
        ^ Just { key1: true, key2: false }
      )
      cxs `shouldEqual` "maybe1 maybe2 maybe3 arr1 arr2 arr3 arr4 arr5 key1"
