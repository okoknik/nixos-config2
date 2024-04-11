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
      lshw # hardware stats
      clinfo # opencl stats
      glxinfo # opengl stats

# programs
      bitwarden-desktop
      zotero
      teams-for-linux
      thunderbird
      steam

# latex
      texstudio
      texliveMedium
# libreoffice
      libreoffice-qt
# kdeconnect airdrop alternative
      kdePackages.kdeconnect-kde     
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

  programs.nixvim = {
    enable = true;
    autoCmd = [
    {
      event = [ "BufEnter" ];
      pattern = [ "*" ];
      command = "silent! :lcd%:p:h";
    }
    ];
    globals.mapleader = " ";
    colorschemes.catppuccin.enable = true;
# for clipboard usage
    clipboard.providers.wl-copy.enable = true;
    opts = {
      clipboard = ["unnamedplus"];
      number = true;        
      relativenumber = true; 
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };
    keymaps = [
# Neotree file manager shortcut
    {
      mode = "n";
      key = "<C-f>";
      options.silent = true;
      action = ":NvimTreeOpen";
    }
# LSP hover()
    {
      mode = "n";
      key = "K";
      options.silent = true;
      action = "vim.lsp.buf.hover";
    }
    {
      mode = "n";
      key = "gd";
      options.silent = true;
      action = "vim.lsp.buf.definition";
    }
    {
      mode = "n";
      key = "ca";
      options.silent = true;
      action = "vim.lsp.buf.codeaction";
    }
    {
      mode = "n";
      key = "gi";
      options.silent = true;
      action = "vim.lsp.buf.implementation";
    }
# Telescope keybinds
    {
      mode = "n";
      key = "<leader>ff";
      options.silent = true;
      action = ":Telescope find_files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      options.silent = true;
      action = ":Telescope live_grep";
    }
    {
      mode = "n";
      key = "<leader>fh";
      options.silent = true;
      action = ":Telescope help_tags";
    }
    {
      mode = "n";
      key = "<leader>fb";
      options.silent = true;
      action = ":Telescope buffers";
    }
    ];

    plugins = {
      lualine = {
        enable = true;
        globalstatus = true;
      };
      nvim-tree = {
        enable = true;
        actions.useSystemClipboard = true;
        view.side = "right"; 
      };
# git
      gitsigns = {
        enable = true;
      };
# shows keybindings
      which-key = {
        enable = true;
      };
# language servers
      lsp = {
        enable = true;
        servers = {
          dockerls.enable = true;
          html.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          sqls.enable = true;
          jsonls.enable = true;
        };
      };
      lint = {
        enable = true;
        lintersByFt = 
        {
          text = ["vale"];
          json = ["jsonlint"];
          markdown = ["vale"];
          python = ["pylint"];
          rst = ["vale"];
          dockerfile = ["hadolint"];
          terraform = ["tflint"];
        };
      };
# formatting
      lsp-format.enable = true;
      treesitter = {
        enable = true;
        ensureInstalled = "all";
        indent = true;
        nixGrammars = true;
      };
      telescope = {
        enable = true;
        extensions = {
          ui-select.enable = true;
        };
      };
# Dashboard
      alpha = {
        enable = true;
        iconsEnabled = true;
        theme = "startify";
      };
# ollama codegemma
      ollama = {
        enable = true;
        model = "codegemma";
        action = "display";
      };
    };
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
