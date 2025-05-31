{config, pkgs, lib, ...}:

{
  environment.systemPackages = with pkgs; [
    neovim
  ];
  environment.variables.EDITOR = lib.mkForce "nvim";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # package = pkgs.neovim;
    # configure = {
    #   customRC = ''
    #     source ~/dotfiles/init.nvim
    #   '';
    # };
  };
}



