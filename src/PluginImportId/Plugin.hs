-- {-# LANGUAGE #-}
{-# OPTIONS_GHC -Wall #-}

-- {-# OPTIONS_GHC -fno-warn-unused-imports #-} -- TEMP
-- {-# OPTIONS_GHC -fno-warn-unused-binds   #-} -- TEMP

----------------------------------------------------------------------
-- |
-- Module      :  PluginImportId.Plugin
-- Copyright   :  (c) 2013 Tabula, Inc.
-- 
-- Maintainer  :  conal@tabula.com
-- Stability   :  experimental
-- 
-- Try importing a name in a GHC plugin
----------------------------------------------------------------------

module PluginImportId.Plugin (plugin) where

import Data.Maybe (fromMaybe)

import GhcPlugins
import IfaceEnv (lookupOrigNameCache)
import qualified OccName as ON


type X a = a -> CoreM a

plugin :: Plugin
plugin = defaultPlugin { installCoreToDos = install }

install :: [CommandLineOption] -> X [CoreToDo]
install _ todo = do
  reinitializeGlobals
  return (CoreDoPluginPass "PluginImportId" (bindsOnlyPass pass) : todo)

pass :: X CoreProgram
pass prog = do _ <- makePrelVar ON.varName "id"
               liftIO $ print "found name"
               return prog

prelMod :: Module
prelMod = mkModule
            (stringToPackageId "base-4.6.0.1")  -- How to determine version number?
            (mkModuleName "GHC.Base")

makePrelVar :: NameSpace -> String -> CoreM Var
makePrelVar ns str =
  do nsc <- getOrigNameCache
     let name :: Name
         name = fromMaybe (error ("mkPrelName: Didn't find " ++ str)) $
                lookupOrigNameCache nsc prelMod (mkOccName ns str)
     lookupId name

