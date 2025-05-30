{ pkgs, ... }:

{
# TODO please change the username & home direcotry to your own

  home.username = "niklas";
  home.homeDirectory = "/home/niklas";

# link the configuration file in current directory to the specified location in home directory

# link all files in `./scripts` to `~/.config/i3/scripts`
# home.file.".config/i3/scripts" = {
#   source = ./scripts;
#   recursive = true;   # link recursively
#   executable = true;  # make all files executable
# };

# basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "okoknik";
    userEmail = "oetkenniklas@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      credential.helper = "manager";
      credential.credentialStore = "cache";
    };
  };

# Packages that should be installed to the user profile.
  home.packages = with pkgs; [
# here is some command line tools I use frequently
# feel free to add your own or remove some of them

    neofetch
    # index nix packages, allows nix-locate
    nix-index

# archives
      zip
      unzip

# networking tools
      dnsutils  # `dig` + `nslookup`
      nmap # A utility for network discovery and security auditing
      mtr # A network diagnostic tool
# utils
      tree
      fzf

# monitoring
      btop  # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

# system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      powertop # battery
      du-dust  # disk space analyzer
      pciutils # lspci
      usbutils # lsusb
      lshw # hardware stats
      clinfo # opencl stats
      glxinfo # opengl stats

# programs
      bitwarden-desktop
      zotero
      teams-for-linux
      thunderbird
      steam
      pandoc
      tidal-hifi
# latex
      texstudio
      texliveFull
# libreoffice
      libreoffice-qt
# kdeconnect airdrop alternative
      kdePackages.kdeconnect-kde 

# lutris gaming
      lutris 
      winetricks  
# clipboard utility for neovim
      wl-clipboard
# alternative tmux
      zellij
# terminal file manager
      yazi
# mounting ios
      libimobiledevice
      ifuse
# file-sharing (airdrop like)
      localsend
# podman-compose
      podman-compose
      ];

# helix - rust neovim alternative
  programs.helix = {
      enable = true;
      defaultEditor = true;
      };

# starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
# custom settings
    settings = {
      add_newline = true;
      line_break.disabled = true;
      time.disabled=false;
    };
  };

# Syncthing
  services.syncthing = {
    enable = true;
};
# alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
# custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

  };

# direnv for development
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; 
    nix-direnv.enable = true;
  };


# Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

# You can update home Manager without changing this value. See
# the home Manager release notes for a list of state version
# changes in each release.
  home.stateVersion = "23.11";

# Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

