
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

# allow unfree packages
  nixpkgs.config.allowUnfree = true;

# ios
  services.usbmuxd.enable = true;

# firmware
  services.fwupd.enable = true;

# qmk
  hardware.keyboard.qmk.enable = true;

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Use AMD GPU drivers
  boot.initrd.kernelModules = [ "amdgpu" ];

# add latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
# Ollama
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
# Docker
  virtualisation = {
    podman = {
      enable = true;
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
  services.xserver.videoDrivers = [ "amdgpu" ];
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
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.zed-mono
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
    git
    chromium
    firefox
    clinfo
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


# make electron apps use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

### GRAPHICS
# Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
# HIP libraries workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

### Audio fixes
#  services.udev.extraRules = ''
# Fix headphone noise when on powersave
# https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
#    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
#    '';


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

