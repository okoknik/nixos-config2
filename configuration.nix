# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./nix-ld.nix
    ];

# allow unfree packages
  nixpkgs.config.allowUnfree = true;

# plymouth
#boot.plymouth.enable = true;

# firmware
  services.fwupd.enable = true;

# qmk
  hardware.keyboard.qmk.enable = true;

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
# For Power consumption
    "mem_sleep_default=deep"
# Workaround iGPU hangs
      "i915.enable_psr=1"
      "nvme.noacpi=1"
  ];

  boot.blacklistedKernelModules = [ 
# This enables the brightness and airplane mode keys to work
    "hid-sensor-hub"
# This fixes controller crashes during sleep
    "cros_ec_lpcs"
    "cros-usbpd-charger"
  ];

# add latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
# Ollama
  services.ollama = {
    enable = true;
  };
# Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    enableNvidia = true;
    storageDriver = "btrfs";

    rootless = {
      enable = true;
      setSocketVariable = false;
      daemon.settings = {
        runtimes = {
          nvidia = {
            path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
          };
        };
      };
    };
  };


# optimize nix-store
  nix.settings.auto-optimise-store = true;

# become trusted user for binary cache
  nix.settings.trusted-users = [ "@wheel" ];

# garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  networking.hostName = "framework"; # Define your hostname.
# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# allow flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Set your time zone.
  time.timeZone = "Europe/Amsterdam";

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
#   font = "Lat2-Terminus16";
    keyMap = "de";
#   useXkbConfig = true; # use xkb.options in tty.
  };

# Enable the X11 windowing system.
  services.xserver.enable = true;
  services = {
    displayManager.sddm.wayland.enable = true;
    displayManager.defaultSession = "plasma";
    displayManager.sddm.theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true; 


# Configure keymap in X11
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

# Configure Flatpak
# services.flatpak.enable = true;

# fonts
  fonts.packages = with pkgs; [
    noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerdfonts
  ];

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
# sound.enable = true;
# hardware.pulseaudio.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };#

# fingerprint
  services.fprintd.enable = lib.mkDefault true;

# configure bluetooth
  hardware.bluetooth.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = true;
    users.niklas = {
      homeMode = "755";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
      packages = with pkgs; [
      ];
    };
  };

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
#   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#   wget
#    discover
    git
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
      ];
    };
  };

### Auto-upgrade via systemd user service
  systemd.services.auto-update = {
    enable = true;
    wantedBy = ["shutdown.target"]; # runs on shutdown
    before = ["shutdown.target"];
    description = "Auto-update user service, runs ~/nixos-config2/update.sh";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/root/nixos-config2/update.sh";
      TimeoutStartSec=0;

      };
    };

  #  system.autoUpgrade = {
  #    enable = true;
  #    flake = "github:okoknik/nixos-config2";
  #    flags = [
  #    "--update-input"
  #    "nixpkgs"
  #    "-L" # print build logs
  #  ];
  #  dates = "02:00";
  #  randomizedDelaySec = "45min";
  #};
  
# make electron apps use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

### THUNDERBOLT
  services.hardware.bolt.enable = true;


### GRAPHICS
# Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

# Modesetting is required.
    modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
    powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

# Use the NVidia open source kernel module
    open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

# eGPU
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
# Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

### Audio fixes
  services.udev.extraRules = ''
# Fix headphone noise when on powersave
# https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
    '';

### Syncthing
  services.syncthing = {
    enable = true;
    user = "niklas";
    dataDir = "/home/niklas/Documents";    # Default folder for new synced folders
# Folder for Syncthing's settings and keys 
      configDir = "/home/niklas/Documents/.config/syncthing";   
    settings.gui = {
      user = "username";
      password = "password";
    };
  };

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  networking.firewall.allowedTCPPortRanges = [ 
  { from = 1714; to = 1764; } # KDE Connect
  ];  
  networking.firewall.allowedUDPPortRanges = [ 
  { from = 1714; to = 1764; } # KDE Connect
  ]; 
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

