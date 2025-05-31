{ config, pkgs, lib, ... }:

let
  cfg = config.main-user;
in
{
  options = {
    main-user.enable = lib.mkEnableOption "Enable the main-user module";
    main-user.username = lib.mkOption {
      default = "gmelodie";
      type = lib.types.str;
      description = "Username for the main user";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      initialPassword = "1234";  # Don't forget to change
      shell = pkgs.zsh;
    };
  };
}



