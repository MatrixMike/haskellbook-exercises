{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Data.IORef
import qualified Data.Map as M
import Data.Maybe (fromMaybe)
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as TL
import System.Environment (getArgs)
import Web.Scotty.Trans

data Config = Config
  { counts :: IORef (M.Map Text Integer)
  , prefix :: Text
  }

type Scotty = ScottyT Text (ReaderT Config IO)

type Handler = ActionT Text (ReaderT Config IO)

bumpBoomp :: Text -> M.Map Text Integer -> (M.Map Text Integer, Integer)
bumpBoomp k m = 
  case M.lookup k m of 
    Nothing -> (M.insert k 1 m    , 1)
    Just x  -> (M.adjust (+1) k m , x+1)

app :: Scotty ()
app =
  get "/:key" $ do
    unprefixed <- param "key" :: Handler Text
    config     <- lift ask
    let key' = mappend (prefix config) unprefixed
    newInteger <- lift . lift $ atomicModifyIORef (counts config) (bumpBoomp key')
    html $
      mconcat ["<h1>Success! Count was: ", TL.pack $ show newInteger, "</h1>"]

main :: IO ()
main = do
  [prefixArg] <- getArgs
  counter     <- newIORef M.empty
  let config = Config counter (TL.pack prefixArg)
      runR   = flip runReaderT config
  scottyT 3000 runR app
