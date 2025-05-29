curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
if ! grep -q "export PATH=/opt/nvim-linux-x86_64/bin:\$PATH" ~/.bashrc; then
	echo "export PATH=/opt/nvim-linux-x86_64/bin:\$PATH" >> ~/.bashrc
fi
sudo rm nvim-linux-x86_64.tar.gz
