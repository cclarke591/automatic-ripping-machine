# Automatic ARM install
sudo groupadd arm
sudo useradd -m arm -g arm -G cdrom
sudo passwd arm

#Add Repository
sudo add-apt-repository ppa:heyarje/makemkv-beta
sudo add-apt-repository ppa:stebbins/handbrake-releases
sudo add-apt-repository ppa:mc3man/bionic-prop
sudo apt-get -q update

sudo apt-get -q install build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev zlib1g-dev

#install makemkv
sudo apt -q install makemkv-bin makemkv-oss

#install handbrake
sudo apt -q install handbrake-cli libavcodec-extra

#install cd ripping stuff
sudo apt install abcde flac imagemagick glyrc cdparanoia

#dependancies
sudo apt -q install at
sudo apt -q install python3 python3-pip
sudo apt-get -q install libcurl4-openssl-dev libssl-dev
sudo apt-get install libdvd-pkg
sudo dpkg-reconfigure libdvd-pkg
sudo apt -q install default-jre-headless

#installation
cd /opt
sudo mkdir arm
sudo chown arm:arm arm
sudo chmod 775 arm
sudo git clone https://github.com/cclarke591/automatic-ripping-machine.git arm
cd arm
# TODO: Remove below line before merging to master
git checkout v2_master
sudo pip3 install -r requirements.txt 
sudo ln -s /opt/arm/setup/51-automedia.rules /lib/udev/rules.d/
sudo ln -s /opt/arm/setup/.abcde.conf /home/arm/
cp docs/arm.yaml.sample arm.yaml
sudo mkdir /etc/arm/
sudo ln -s /opt/arm/arm.yaml /etc/arm/

#create mounting directory
sudo mkdir -p /mnt/dev/sr0
