sudo add-apt-repository -y ppa:kitware/ppa
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

sudo apt update && sudo apt install -y software-properties-common cmake gcc g++

sudo ln -sf /usr/bin/gcc /usr/bin/cc
