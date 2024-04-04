DISK=/dev/sda
MAPPER=/dev/mapper/crypted

######################
# Installation
# partition disk
sudo parted "$DISK" -- mklabel gpt
sudo parted "$DISK" -- mkpart ESP fat32 1MB 512MB
sudo parted "$DISK" -- set 1 esp on
sudo parted "$DISK" -- mkpart Swap linux-swap 512MiB 4GiB
sudo mkswap -L SWAP "$DISK"2
sudo swapon "$DISK"2
sudo parted "$DISK" -- mkpart primary 4GiB 100%
sudo mkfs.fat -F 32 -n BOOT  "$DISK"1

# encrypt
sudo cryptsetup luksFormat "$DISK"3
sudo cryptsetup luksConfig "$DISK"3 --label NIXOS
sudo cryptsetup luksOpen "$DISK"3 crypted

# btrfs
sudo mkfs.btrfs -L ButterFS "$MAPPER"
sudo mount -t btrfs "$MAPPER" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/log

sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
sudo umount /mnt

# mounting
sudo mount -o subvol=root,compress=zstd,noatime "$MAPPER" /mnt

sudo mkdir /mnt/home
sudo mount -o subvol=home,compress=zstd,noatime "$MAPPER" /mnt/home

sudo mkdir /mnt/nix
sudo mount -o subvol=nix,compress=zstd,noatime "$MAPPER" /mnt/nix

sudo mkdir /mnt/persist
sudo mount -o subvol=persist,compress=zstd,noatime "$MAPPER" /mnt/persist

sudo mkdir -p /mnt/var/log
sudo mount -o subvol=log,compress=zstd,noatime "$MAPPER" /mnt/var/log

sudo mkdir /mnt/boot
sudo mount "$DISK"1 /mnt/boot -o umask=0077

sudo nixos-generate-config --root /mnt

###################
# Configuration
read -p "Enter Your New Hostname: [ framework ] " hostName
echo "-----"

# cp host options.nix
mkdir hosts/$hostName
cp options.nix hosts/$hostName
git add .
sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix
sed -i "/^\s*setHostname[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./hosts/$hostName/options.nix
echo "Set-up done"

###################
#options
echo "-----"
echo "Set options"
installusername=$(echo $USER)
read -p "Enter Your Username: [ $installusername ] " userName
sed -i "/^\s*setUsername[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$userName\"/" ./hosts/$hostName/options.nix

# git
read -p "Enter Your New Git Username: [ John Smith ] " gitUserName
if [ -z "$gitUserName" ]; then
  gitUserName="John Smith"
fi
sed -i "/^\s*gitUsername[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$gitUserName\"/" ./hosts/$hostName/options.nix
echo "-----"
read -p "Enter Your New Git Email: [ johnsmith@gmail.com ] " gitEmail
if [ -z "$gitEmail" ]; then
  gitEmail="johnsmith@gmail.com"
fi
sed -i "/^\s*gitEmail[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$gitEmail\"/" ./hosts/$hostName/options.nix

# time + locale
echo "-----"
read -p "Enter Your Locale: [ en_US.UTF-8 ] " locale
if [ -z "$locale" ]; then
  locale="en_US.UTF-8"
fi
sed -i "/^\s*theLocale[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$locale\"/" ./hosts/$hostName/options.nix
echo "-----"
read -p "Enter Your Timezone: [ Europe/Berlin ] " timezone
if [ -z "$timezone" ]; then
  timezone="Europe/Berlin"
fi
escaped_timezone=$(echo "$timezone" | sed 's/\//\\\//g')
sed -i "/^\s*theTimezone[[:space:]]*=[[:space:]]*\"/s#\"\(.*\)\"#\"$escaped_timezone\"#" ./hosts/$hostName/options.nix

# keyboard layout
echo "-----"
read -p "Enter Your Keyboard Layout: [ de ] " kbdLayout
if [ -z "$kbdLayout" ]; then
  kbdLayout="de"
fi
sed -i "/^\s*theKBDLayout[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$kbdLayout\"/" ./hosts/$hostName/options.nix

##############
# programs
# syncthing
echo "-----"
read -p "Install Syncthing: [ false ] " enableSyncthing
if [ -z "$enableSyncthing" ]; then
  enableSyncthing="false"
fi
user_input_lower=$(echo "$enableSyncthing" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  y|yes|true|t|enable)
    enableSyncthing="true"
    ;;
  *)
    enableSyncthing="false"
    ;;
esac
sed -i "/^\s*syncthing[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$enableSyncthing\"/" ./hosts/$hostName/options.nix

# printer
echo "-----"

read -p "Enable Printer Support: [ false ] " printers
if [ -z "$printers" ]; then
  printers="false"
fi
user_input_lower=$(echo "$printers" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  y|yes|true|t|enable)
    printers="true"
    ;;
  *)
    printers="false"
    ;;
esac
sed -i "/^\s*printer[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$printers\"/" ./hosts/$hostName/options.nix

# flatpak
echo "-----"
read -p "Enable Flatpak Support: [ false ] " flatpaks
if [ -z "$flatpaks" ]; then
  flatpaks="false"
fi
user_input_lower=$(echo "$printers" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  y|yes|true|t|enable)
    flatpaks="true"
    ;;
  *)
    flatpaks="false"
    ;;
esac
sed -i "/^\s*flatpak[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$flatpaks\"/" ./hosts/$hostName/options.nix

# python
echo "-----"
read -p "Enable Python & Pycharm Support: [ false ] " pythonEnable
if [ -z "$pythonEnable" ]; then
  pythonEnable="false"
fi
user_input_lower=$(echo "$pythonEnable" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  y|yes|true|t|enable)
    pythonEnable="true"
    ;;
  *)
    pythonEnable="false"
    ;;
esac
sed -i "/^\s*python[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$pythonEnable\"/" ./hosts/$hostName/options.nix

############## 
# hardware
# cpu
echo "-----"
echo "Valid options include amd, intel, and vm"
read -p "Enter Your CPU Type: [ intel ] " cpuType
user_input_lower=$(echo "$cpuType" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  amd)
    cpuType="amd"
    ;;
  intel)
    cpuType="intel"
    ;;
  vm)
    cpuType="vm"
    ;;
  *)
    echo "Option Entered Not Available, Falling Back To [ intel ] Option."
    sleep 1
    cpuType="intel"
    ;;
esac
sed -i "/^\s*cpuType[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$cpuType\"/" ./hosts/$hostName/options.nix

# gpu
echo "-----"
echo "Valid options include amd, intel, nvidia, vm, intel-nvidia, none"
read -p "Enter Your GPU Type : " gpuType
user_input_lower=$(echo "$gpuType" | tr '[:upper:]' '[:lower:]')
case $user_input_lower in
  amd)
    gpuType="amd"
    ;;
  intel)
    gpuType="intel"
    ;;
  vm)
    gpuType="vm"
    ;;
  nvidia)
    gpuType="nvidia"
    ;;
  intel-nvidia)
    gpuType="intel-nvidia"
    ;;
  *)
    echo "Option Entered Not Available, Falling Back To [ none ] Option."
    sleep 1
    gpuType="none"
    ;;
esac
sed -i "/^\s*gpuType[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$gpuType\"/" ./hosts/$hostName/options.nix

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"
echo "Now Going To Build The OS, 🤞"
git commit -am "Add new hosts folder and all the new settings"
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#$hostName




