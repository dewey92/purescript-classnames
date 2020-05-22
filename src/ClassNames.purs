module ClassNames
  ( class ClassNames
  , classNames'
  , classNames
  , type (^)
  , (^)
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)
import Data.Tuple (Tuple(..))
import Prim.Row as Row
import Prim.RowList as RL
import Record (get)
import Type.Data.RowList (RLProxy(..))

infixr 6 type Tuple as ^
infixr 6 Tuple as ^

classNames :: ∀ a. ClassNames a => a -> String
classNames a = joinWith " " $ classNames' a

class ClassNames a where
  classNames' :: a -> Array String

instance strClassNames :: ClassNames String where
  classNames' str = [str]

instance arrClassNames :: ClassNames a => ClassNames (Array a) where
  classNames' = (=<<) classNames'

instance maybeClassNames :: ClassNames a => ClassNames (Maybe a) where
  classNames' Nothing = []
  classNames' (Just a) = classNames' a

instance tupleClassNames :: (ClassNames l, ClassNames r) => ClassNames (l ^ r) where
  classNames' (l ^ r) = classNames' l <> classNames' r

instance recordClassNames :: (RecordClassName row rl, RL.RowToList row rl) => ClassNames (Record row) where
  classNames' row = recToClassNames row (RLProxy :: RLProxy rl)

class RecordClassName (input :: # Type) (rl :: RL.RowList) where
  recToClassNames :: Record input -> RLProxy rl -> Array String

instance emptyRecordClassName :: RecordClassName input RL.Nil where
  recToClassNames _ _ = []

instance boolRecordClassName
  ::
  ( RecordClassName row tail
  , IsSymbol label
  , Row.Cons label Boolean rowTail row
  ) => RecordClassName row (RL.Cons label Boolean tail) where
  recToClassNames obj _ = classname <> rest where
    key = SProxy :: SProxy label
    value = get key obj
    classname = if value then [reflectSymbol key] else []
    rest = recToClassNames obj (RLProxy :: RLProxy tail)
