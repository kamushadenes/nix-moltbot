{ pkgs
, sourceInfo ? import ../sources/clawdbot-source.nix
}:
let
  toolSets = import ../tools/extended.nix { pkgs = pkgs; };
  clawdbotGateway = pkgs.callPackage ./clawdbot-gateway.nix { inherit sourceInfo; };
  clawdbotApp = pkgs.callPackage ./clawdbot-app.nix { };
  clawdbotToolsBase = pkgs.buildEnv {
    name = "clawdbot-tools-base";
    paths = toolSets.base;
  };
  clawdbotToolsExtended = pkgs.buildEnv {
    name = "clawdbot-tools-extended";
    paths = toolSets.extended;
  };
  clawdbotBundle = pkgs.callPackage ./clawdbot-batteries.nix {
    clawdbot-gateway = clawdbotGateway;
    clawdbot-app = clawdbotApp;
    extendedTools = toolSets.base;
  };
in {
  clawdbot-gateway = clawdbotGateway;
  clawdbot-app = clawdbotApp;
  clawdbot = clawdbotBundle;
  clawdbot-tools-base = clawdbotToolsBase;
  clawdbot-tools-extended = clawdbotToolsExtended;
}
