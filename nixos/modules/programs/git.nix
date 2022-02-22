{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
in

{
  options = {
    programs.git = {
      enable = mkEnableOption "git";

      package = mkPackageOption pkgs "git" {
        example = [ "gitFull" ];
      };

      config = mkOption {
        type = with types; attrsOf (attrsOf anything);
        default = { };
        example = {
          init.defaultBranch = "main";
          url."https://github.com/".insteadOf = [ "gh:" "github:" ];
        };
        description = ''
          Configuration to write to /etc/gitconfig. See the CONFIGURATION FILE
          section of git-config(1) for more information.
        '';
      };

      lfs = {
        enable = mkEnableOption "git-lfs";
        package = mkPackageOption pkgs "git-lfs" { };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      environment.etc.gitconfig = mkIf (cfg.config != {}) {
        text = generators.toGitINI cfg.config;
      };
    })
    (mkIf (cfg.enable && cfg.lfs.enable) {
      environment.systemPackages = [ cfg.lfs.package ];
      programs.git.config = {
        filter.lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    })
  ];

  meta.maintainers = with maintainers; [ figsoda ];
}
