{ config, pkgs, lib, ... }:

let
  user = "gmelodie";
  dotfiles = "/home/${user}/dotfiles";
  hostname = "nixos";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = ${hostname};
  time.timeZone = "America/Sao_Paulo";

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      espanso
      fira-code-symbols
    ];
  };

  environment.systemPackages = with pkgs; [
    golang
    python3
    rustup
    gnupg
    zsh
    oh-my-zsh
    neovim
  ];

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  # keyd setup but disabled by default
  services.keyd = {
    enable = false;
    # You can later add configuration here, e.g. key remapping
    settings = builtins.readFile ../keyd.conf;
  };

  services.espanso.enable = true;

  fonts.packages = with pkgs; [
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  system.activationScripts.dotfiles = {
    text = ''
      ln -sf ${dotfiles}/zshrc /home/${user}/.zshrc
      ln -sf ${dotfiles}/gitconfig /home/${user}/.gitconfig

      mkdir -p /home/${user}/.config/espanso
      ln -sf ${dotfiles}/espanso.yml /home/${user}/.config/espanso/config.yml

      mkdir -p /home/${user}/.config/nvim
      ln -sf ${dotfiles}/init.vim /home/${user}/.config/nvim/init.vim

      chown -h ${user}:${user} /home/${user}/.zshrc
      chown -h ${user}:${user} /home/${user}/.gitconfig
      chown -h ${user}:${user} /home/${user}/.config/espanso/config.yml
      chown -h ${user}:${user} /home/${user}/.config/nvim/init.vim
    '';
  };


  system.stateVersion = "25.04";
}

