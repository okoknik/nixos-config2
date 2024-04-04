# PLEASE READ THE WIKI FOR DETERMINING
# WHAT TO PUT HERE AS OPTIONS. 
# https://gitlab.com/Zaney/zaneyos/-/wikis/Setting-Options

let
  setUsername = "defaultuser";
  setHostname = "nixos";
in {
  # No Change Needed Below
  username = "${setUsername}";
  hostname = "${setHostname}";
  userHome = "/home/${setUsername}";
  flakeDir = "/home/${setUsername}/nixos-config2";
  wallpaperDir = "/home/${setUsername}/Pictures/Wallpapers";
  screenshotDir = "/home/${setUsername}/Pictures/Screenshots";
  flakePrev = "/home/${setUsername}/.os-previous";
  flakeBackup = "/home/${setUsername}/.os-backup";

  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "John Smith";
  gitEmail = "johnsmith@gmail.com";

  # Base16 Theme
  theme = "atelier-cave";

  # System Settings
  theLocale = "en_US.UTF-8";
  theKBDLayout = "us";
  theKBDVariant = "";
  theLCVariables = "en_US.UTF-8";
  theTimezone = "America/Chicago";
  theShell = "bash"; # Possible options: bash, zsh
  theKernel = "zen"; # Possible options: default, latest, lqx, xanmod, zen
  sdl-videodriver = "x11"; # Either x11 or wayland ONLY. Games might require x11 set here
  # For Hybrid Systems intel-nvidia
  # Should Be Used As gpuType
  cpuType = "intel";
  gpuType = "intel";

  # Nvidia Hybrid Devices ONLY NEEDED FOR HYBRID SYSTEMS! 
  intel-bus-id = "PCI:1:0:0";
  nvidia-bus-id = "PCI:0:2:0";

  # Enable / Setup NFS
  nfs = false;
  nfsMountPoint = "/mnt/nas";
  nfsDevice = "nas:/volume1/nas";

  # NTP & HWClock Settings
  ntp = true;
  localHWClock = false;

  # Enable Printer & Scanner Support
  printer = false;

  # Program Options
  browser = "firefox"; # Install & Set Default Browser
  terminal = "kitty";  # Set Default System Terminal
  distrobox = false;
  flatpak = false;
  kdenlive = false;
  blender = false;
  enableZeroAD = false;

}
