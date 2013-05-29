Experimenting with GHC plugins.
Trying to make an qualified name for (later) use in generated Core code.

The simple plugin is defined in `src/PluginImportId/Plugin.hs` and a test module in `TestImportId.hs`.
To test,

    ghc -package ghc -fplugin PluginImportId.Plugin TestImportId.hs

The result I get (with GHC 7.6.3):

    [1 of 1] Compiling TestImportId     ( TestImportId.hs, TestImportId.o )
    Loading package ghc-prim ... linking ... done.
    Loading package integer-gmp ... linking ... done.
    Loading package base ... linking ... done.
    ...
    Loading package ghc-7.6.3 ... linking ... done.
    Loading package plugin-import-id-0.1 ... linking ... done.
    ghc: panic! (the 'impossible' happened)
      (GHC version 7.6.3 for x86_64-apple-darwin):
            mkPrelName: Didn't find id

I get the same failure with GHC 7.4.2.

What's going wrong?
