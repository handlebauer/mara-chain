{ lib
, buildGoApplication
, rev ? "dirty"
}:
let
  version = "v0.17.1";
  pname = "marad";
  tags = [ "ledger" "netgo" ];
  ldflags = lib.concatStringsSep "\n" ([
    "-X github.com/cosmos/cosmos-sdk/version.Name=mara"
    "-X github.com/cosmos/cosmos-sdk/version.AppName=${pname}"
    "-X github.com/cosmos/cosmos-sdk/version.Version=${version}"
    "-X github.com/cosmos/cosmos-sdk/version.BuildTags=${lib.concatStringsSep "," tags}"
    "-X github.com/cosmos/cosmos-sdk/version.Commit=${rev}"
  ]);
in
buildGoApplication rec {
  inherit pname version tags ldflags;
  src = lib.sourceByRegex ./. [
    "^(x|app|cmd|client|server|crypto|rpc|types|encoding|ethereum|indexer|testutil|version|go.mod|go.sum|gomod2nix.toml)($|/.*)"
    "^tests(/.*[.]go)?$"
  ];
  modules = ./gomod2nix.toml;
  doCheck = false;
  pwd = src; # needed to support replace
  subPackages = [ "cmd/marad" ];
  CGO_ENABLED = "1";

  meta = with lib; {
    description = "Mara-chain is a scalable and interoperable Ethereum library, built on Proof-of-Stake with fast-finality using the Cosmos SDK which runs on top of Tendermint Core consensus engine.";
    homepage = "https://github.com/mara-labs/mara-chain";
    license = licenses.asl20;
    mainProgram = "marad";
  };
}