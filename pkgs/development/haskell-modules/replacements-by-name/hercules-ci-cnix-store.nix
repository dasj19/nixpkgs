{
  mkDerivation,
  base,
  boost,
  bytestring,
  Cabal,
  cabal-pkg-config-version-hook,
  conduit,
  containers,
  exceptions,
  hspec,
  hspec-discover,
  inline-c,
  inline-c-cpp,
  lib,
  nix,
  protolude,
  template-haskell,
  temporary,
  text,
  unix,
  unliftio-core,
  vector,
}:
mkDerivation {
  pname = "hercules-ci-cnix-store";
  version = "0.3.7.0";
  sha256 = "6feba2a6e1a267bc69b67962ed6eaa3510b1ae31c411fdb4e6670763d175d3b1";
  setupHaskellDepends = [
    base
    Cabal
    cabal-pkg-config-version-hook
  ];
  libraryHaskellDepends = [
    base
    bytestring
    conduit
    containers
    inline-c
    inline-c-cpp
    protolude
    template-haskell
    unix
    unliftio-core
    vector
  ];
  librarySystemDepends = [ boost ];
  libraryPkgconfigDepends = [ nix ];
  testHaskellDepends = [
    base
    bytestring
    containers
    exceptions
    hspec
    inline-c
    inline-c-cpp
    protolude
    temporary
    text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Haskell bindings for Nix's libstore";
  license = lib.licenses.asl20;
}
