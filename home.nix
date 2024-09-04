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
    userName = "okoknik";
    userEmail = "oetkenniklas@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
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
      ];


  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    plugins = with pkgs; [
    {
      plugin = tmuxPlugins.cpu;
    }
    {
      plugin = tmuxPlugins.catppuccin;
      extraConfig = ''
        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"
        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
        set -g @catppuccin_status_modules_right "directory cpu date_time"
        set -g @catppuccin_status_modules_left "session"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator " "
        set -g @catppuccin_status_right_separator_inverse "no"
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"
        set -g @catppuccin_directory_text "#{b:pane_current_path}"
        set -g @catppuccin_date_time_text "%H:%M"
        '';
    }
    {
      plugin = tmuxPlugins.resurrect;
      extraConfig = ''
        set -g @resurrect-strategy-vim 'session'
        set -g @resurrect-strategy-nvim 'session'
        set -g @resurrect-capture-pane-contents 'on'
        '';
    }
    ];

  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
    ];
  };

# neovim
programs.neovim = {
  enable = true;
}

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

