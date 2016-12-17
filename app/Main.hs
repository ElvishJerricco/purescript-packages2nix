module Main where

import Control.Lens
import Data.Aeson
import qualified Data.ByteString.Lazy as ByteString
import qualified Data.Map as Map
import qualified Data.Text.IO as Text
import Lib
import System.Exit
import System.IO

main :: IO ()
main = do
  Just unsafeDecoded <- decode <$> ByteString.hGetContents stdin
  let decoded =
        (dependencies %~ fmap safeName) <$>
        Map.mapKeys safeName unsafeDecoded
  Text.putStr $ packagesToNix decoded
  exitSuccess
