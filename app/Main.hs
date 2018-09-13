{-# LANGUAGE OverloadedStrings #-}
module Main where

--import Lib
--import qualified Data.ByteString.Lazy.Char8 as L8
--import           Network.HTTP.Simple

--main :: IO ()
--main = do
--    response <- httpLBS "http://httpbin.org/get"
--
--    putStrLn $ "The status code was: " ++
--               show (getResponseStatusCode response)
--    print $ getResponseHeader "Content-Type" response
--    L8.putStrLn $ getResponseBody response

-- import           Data.Aeson            (Value)
--import qualified Data.ByteString.Char8 as S8
--import qualified Data.Yaml             as Yaml
--import           Network.HTTP.Simple

--main :: IO ()
--main = do
--    response <- httpJSON "POST http://httpbin.org/post"
--    putStrLn $ "The status code was: " ++ show (getResponseStatusCode response)
--    print $ getResponseHeader "Content-Type" response
--    S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)

import qualified Data.HashMap.Strict as HM
import           Data.Aeson
import           Network.HTTP.Simple
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.Text as T
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    let user = args !! 0
    let psw = args !! 1
    token <- signIn user psw
    print token

-- :set -XOverloadedStrings
-- import qualified Data.HashMap.Strict as HM
-- import Data.Aeson
-- resp <- httpJSON "POST http://httpbin.org/post" :: IO (Response Object)
-- body = getResponseBody resp
-- HM.lookup "origin" body

signIn :: String -> String -> IO String
signIn username password = do
    let packeduser = T.pack username
    let packedpsw = T.pack password
    let cred = Object $ HM.fromList [ ("username", String packeduser), ("password", String packedpsw) ]
    let request = setRequestBodyJSON cred
                $ setRequestHeader "Accept" ["text/plain"]
                $ setRequestHeader "Content-Type" ["application/json"]
                $ "POST http://localhost:18080/app/api/auth/signin"
    resp <- httpLBS request
    return $ L8.unpack $ getResponseBody resp

