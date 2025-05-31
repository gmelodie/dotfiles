{config, pkgs, lib, ...}:

{
  imports =
    [
      ./main-user.nix
    ];

  users.users.${config.main-user.username}.shell = pkgs.zsh;
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    fzf
  ];

  # Prevent the new user dialog in zsh
  system.userActivationScripts.zshrc = "touch .zshrc";

  environment.variables = {
    # Go-related environment variables
    GOPATH = "/home/${config.main-user.username}/go";
    GO111MODULE = "on";  # (Related to nvim-go, controls Go modules support)
    
    # Modify PATH to include Go
    PATH = "/usr/local/go/bin:/home/${config.main-user.username}/go/bin:$HOME/.local/bin:/home/${config.main-user.username}/.cargo/bin:/home/${config.main-user.username}/dotfiles/scripts:/home/${config.main-user.username}/.nimble/bin:$PATH";
    
    # Some magic to make gpg2 work
    GPG_TTY = "$(tty)";
    
    # Virtualenvwrapper (Python) settings
    WORKON_HOME = "/home/${config.main-user.username}/.virtualenvs";
    
    # Wine settings
    WINEARCH = "win32";
    WINEPREFIX = "/home/${config.main-user.username}/wine32";
    
    # Cargo run coloring
    CARGO_TERM_COLOR = "always";
  };


  programs.zsh = {
    enable = true;
    enableCompletion = true;

    histSize = 20000;

    shellAliases = {
      psf = "ps -aux | grep";
      lsf = "ls | grep";

      dkclean = "docker container rm $(docker container ls -aq)";

      # nix
      nclean =
        "nix-collect-garbage -d && nix-store --gc && nix-store --verify --check-contents && nix store optimise";
      nsh = "nix-shell";
      nse = "nix search nixpkgs";
      ghostscript = "/bin/gs";
      gs = "git status";
      gh = "git checkout";
      gb = "git checkout -b";
      gd = "git branch --delete";
      gpf = "git push -f";
      say = "spd-say";
      digs = "dig +noall +answer +authority";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "vi-mode" "fzf" "colored-man-pages" "fancy-ctrl-z" ];
      theme = "robbyrussell";
    };


    shellInit = ''
      # force close any
      # usage: fclose stremio
      function fclose {
          for process in $(ps aux | grep $1 | cut -d " " -f 5); do
              kill -9 $process 2>/dev/null;
          done
      }
      
      setopt +o nomatch # https://unix.stackexchange.com/a/310553/235577
      for script in $(ls $HOME/scripts/*.sh 2>/dev/null); do
          source $script
      done
      
    '';

  };

}

