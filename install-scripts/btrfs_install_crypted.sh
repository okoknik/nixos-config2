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
