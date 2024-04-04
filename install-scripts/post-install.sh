###################
# Configuration
read -p "Enter Your New Hostname: [ framework ] " hostName
if [ -z "$hostName" ]; then
  hostName="framework"
fi
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

##############
# programs
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
