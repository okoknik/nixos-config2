{ config, pkgs, ... }:

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
    userName = "simstuff";
    userEmail = "oetkenniklas@gmail.com";
    #config = {
     # defaultBranch = "main";
      #gpg.format = "ssh";
      #user.signingkey = "~/.ssh/id_rsa.pub";
    #};
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch

    # archives
    zip

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
  ];

 programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    ms-python.python
  ];
};

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
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

  # Create XDG Dirs
  xdg = {
    userDirs = {
        enable = true;
        createDirectories = true;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
