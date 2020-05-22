# purescript-classnames

A simple Purescript utility for conditionally joining classNames together. Heavily inspired by the javascript counterpart [classnames](https://www.npmjs.com/package/classnames)

# Usage

You can combine strings, arrays, `Maybe`s, and a record of booleans altogether.

```purs
import ClassNames
  ( classNames
  , (^) -- Just an alias of `Tuple`
  )

classNames ("flex-row" ^ "center") -- "flex-row center"
classNames ("flex-row" ^ Nothing ^ Just "is-mobile") -- "flex-row is-mobile"
classNames (["flex-row", "is-mobile"] ^ "center") -- "flex-row is-mobile center"
classNames ({
  "flex-row": true,
  "is-mobile": false,
  "center": true,
} ^ [Just "container"]) -- "center flex-row container"
```

Note that when you pass a record of booleans, the resulting value will be in alphabetical order as it's using `RowToList` under the hood.

## Integration with Other Libraries

If your library forces you to wrap the classNames in a newtype, you can still use it by creating your own utility function with `classNames'`. For instance, Halogen requires classNames to be wrapped in `Halogen.HTML.ClassName`.

```purs
import ClassNames (class ClassNames, classNames')
import Halogen.HTML as H
import Halogen.HTML.Properties as P

csx :: ∀ a r i. ClassNames a => a -> H.IProp ( class :: String | r ) i
csx a = P.classes $ map H.ClassName (classNames' a)
```

Basically `classNames'` returns `Array String` which you cann then transform to the data structure you want.

# License
MIT. Copyright (c) 2020 Jihad D. Waspada.
