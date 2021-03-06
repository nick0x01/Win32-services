module System.Win32.SystemServices.Services.SVC_ACCESS_RIGHTS
  ( SVC_ACCESS_RIGHTS (..)
  , toDWORD
  , flag
  ) where

import Data.Bits
import Data.Maybe
import System.Win32.Types
import Text.Printf
import Import

data SVC_ACCESS_RIGHTS
  = SVC_AR_ALL_ACCESS
  | SVC_AR_CHANGE_CONFIG
  | SVC_AR_ENUMERATE_DEPENDENTS
  | SVC_AR_INTERROGATE
  | SVC_AR_PAUSE_CONTINUE
  | SVC_AR_QUERY_CONFIG
  | SVC_AR_QUERY_STATUS
  | SVC_AR_START
  | SVC_AR_STOP
  | SVC_AR_USER_DEFINED_CONTROL
  deriving (Show)

toDWORD :: SVC_ACCESS_RIGHTS -> DWORD
toDWORD SVC_AR_ALL_ACCESS            = 0x000F01FF
toDWORD SVC_AR_CHANGE_CONFIG         = 0x00000002
toDWORD SVC_AR_ENUMERATE_DEPENDENTS  = 0x00000008
toDWORD SVC_AR_INTERROGATE           = 0x00000080
toDWORD SVC_AR_PAUSE_CONTINUE        = 0x00000040
toDWORD SVC_AR_QUERY_CONFIG          = 0x00000001
toDWORD SVC_AR_QUERY_STATUS          = 0x00000004
toDWORD SVC_AR_START                 = 0x00000010
toDWORD SVC_AR_STOP                  = 0x00000020
toDWORD SVC_AR_USER_DEFINED_CONTROL  = 0x00000100

fromDWORD :: DWORD -> Either String SVC_ACCESS_RIGHTS
fromDWORD 0x000F01FF = Right SVC_AR_ALL_ACCESS
fromDWORD 0x00000002 = Right SVC_AR_CHANGE_CONFIG
fromDWORD 0x00000008 = Right SVC_AR_ENUMERATE_DEPENDENTS
fromDWORD 0x00000080 = Right SVC_AR_INTERROGATE
fromDWORD 0x00000040 = Right SVC_AR_PAUSE_CONTINUE
fromDWORD 0x00000001 = Right SVC_AR_QUERY_CONFIG
fromDWORD 0x00000004 = Right SVC_AR_QUERY_STATUS
fromDWORD 0x00000010 = Right SVC_AR_START
fromDWORD 0x00000020 = Right SVC_AR_STOP
fromDWORD 0x00000100 = Right SVC_AR_USER_DEFINED_CONTROL
fromDWORD x = Left $ "The " ++ printf "%x" x ++ " control code is unsupported by this binding."

unflag :: DWORD -> [SVC_ACCESS_RIGHTS]
unflag f = mapMaybe (hush . fromDWORD . (.&. f)) masks
  where
    masks = take 32 $ iterate (`shiftL` 1) 1

flag :: [SVC_ACCESS_RIGHTS] -> DWORD
flag = foldl (\flag' f -> flag' .|. toDWORD f) 0
