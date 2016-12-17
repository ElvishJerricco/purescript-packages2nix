{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Control.Lens
import Data.Aeson
import Data.Aeson.TH
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Monoid
import Data.Text (Text)
import qualified Data.Text as Text

data Package = Package
  { _dependencies :: [Text]
  , _repo :: Text
  , _version :: Text
  } deriving (Eq, Ord, Show, Read)

makeLenses ''Package
deriveJSON defaultOptions {fieldLabelModifier = drop 1} ''Package

safeName :: Text -> Text
safeName unsafeName = if unsafeName == "assert"
  then "purescript-assert"
  else unsafeName

packagesToNix :: Map Text Package -> Text
packagesToNix pkgs = Text.intercalate "\n"
  [ "{ pkgs, callPackage }:"
  , ""
  , "self: {"
  , mappend "  " $ Text.replace "\n" "\n  " $ Map.foldMapWithKey pkgToField pkgs
  , "}"
  ]

pkgToField :: Text -> Package -> Text
pkgToField name pkg = name <> " = " <> pkgToNix name pkg <> " {};\n"

pkgToNix :: Text -> Package -> Text
pkgToNix name pkg = Text.intercalate "\n"
  [ "callPackage"
  , "  ({ " <> Text.intercalate ", " ("mkDerivation" : pkg^.dependencies) <> " }:"
  , "    mkDerivation {"
  , "      pname = \"" <> name <> "\";"
  , "      version = \"" <> (pkg^.version) <> "\";"
  , "      purescriptDepends = [ " <> Text.intercalate " " (pkg^.dependencies) <> " ];"
  , "      src = pkgs.fetchgit {"
  , "        url = " <> (pkg^.repo) <> ";"
  , "        sha256 = null;"
  , "        rev = \"refs/tags/" <> (pkg^.version) <> "\";"
  , "      };"
  , "    })"
  ]
