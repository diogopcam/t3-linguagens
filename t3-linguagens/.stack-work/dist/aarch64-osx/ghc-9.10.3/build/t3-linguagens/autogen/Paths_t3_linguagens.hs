{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_t3_linguagens (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/bin"
libdir     = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/lib/aarch64-osx-ghc-9.10.3-fe9c/t3-linguagens-0.1.0.0-Hxuvn8PYWehBA65j3WliRt-t3-linguagens"
dynlibdir  = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/lib/aarch64-osx-ghc-9.10.3-fe9c"
datadir    = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/share/aarch64-osx-ghc-9.10.3-fe9c/t3-linguagens-0.1.0.0"
libexecdir = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/libexec/aarch64-osx-ghc-9.10.3-fe9c/t3-linguagens-0.1.0.0"
sysconfdir = "/Users/diogpcam/Desktop/t3-linguagens/t3-linguagens/.stack-work/install/aarch64-osx/eeabde280abbc2320afaeb5a239ea732dd2a8f4e567b27b3930efdf2aed3d9c0/9.10.3/etc"

getBinDir     = catchIO (getEnv "t3_linguagens_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "t3_linguagens_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "t3_linguagens_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "t3_linguagens_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "t3_linguagens_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "t3_linguagens_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
