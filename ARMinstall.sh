# Automatic ARM install
sudo groupadd arm
sudo useradd -m arm -g arm -G cdrom
sudo passwd arm

#Add Repository
sudo add-apt-repository ppa:heyarje/makemkv-beta
sudo add-apt-repository ppa:stebbins/handbrake-releases
sudo add-apt-repository ppa:mc3man/bionic-prop

sudo add-apt-repository -n "deb http://archive.ubuntu.com/ubuntu bionic universe multiverse"
sudo add-apt-repository -n "deb http://us.archive.ubuntu.com/ubuntu/ bionic universe"
sudo add-apt-repository -n "deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe"
sudo add-apt-repository -n "deb http://us.archive.ubuntu.com/ubuntu/ bionic multiverse"
sudo add-apt-repository -n "deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates multiverse"
sudo add-apt-repository -n "deb http://security.ubuntu.com/ubuntu bionic-security universe"
sudo add-apt-repository -n "deb http://security.ubuntu.com/ubuntu bionic-security multiverse"

sudo apt-get update



#install makemkv
sudo apt install makemkv-bin makemkv-oss -y

#install handbrake
sudo apt install handbrake-cli libavcodec-extra -y

#install cd ripping stuff
sudo apt install abcde flac imagemagick glyrc cdparanoia -y

#dependancies
sudo apt install gcc libcurl4-gnutls-dev libtesseract-dev pkg-config -y
sudo apt install at
sudo apt install python3 python3-pip -y
sudo apt-get install libcurl4-openssl-dev libssl-dev -y
sudo apt-get install libdvd-pkg -y
sudo dpkg-reconfigure libdvd-pkg -y
sudo apt install default-jre-headless -y

#Install CCExtractor (Required for MakeMKV1.14.1 and Later)**

git clone https://github.com/CCExtractor/ccextractor
cd ccextractor/linux
./autogen.sh
./configure
sudo make
sudo make install
cd /usr/bin/
sudo ln -s /usr/local/bin/ccextractor mmccextr

#installation
cd /opt
sudo mkdir arm
sudo chown arm:arm arm
sudo chmod 775 arm
sudo git clone https://github.com/cclarke591/automatic-ripping-machine.git arm
cd arm
# TODO: Remove below line before merging to master
# git checkout v2_master
sudo pip3 install -r requirements.txt
sudo ln -s /opt/arm/setup/51-automedia.rules /lib/udev/rules.d/
sudo ln -s /opt/arm/setup/.abcde.conf /home/arm/
cp docs/arm.yaml.sample arm.yaml
sudo mkdir /etc/arm/
sudo ln -s /opt/arm/arm.yaml /etc/arm/

#create mounting directory
sudo mkdir -p /mnt/dev/sr0

#allow non root mounting
echo "/dev/sr0  /mnt/dev/sr0  udf,iso9660  user,noauto,exec,utf8  0  0" | sudo tee -a /etc/fstab
