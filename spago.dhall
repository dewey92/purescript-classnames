{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "classnames"
, license = "MIT"
, repository = "https://github.com/dewey92/purescript-classnames"
, dependencies =
  [ "console", "effect", "psci-support", "record", "spec", "strings" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
