# Purpose
I keep my dotfiles public so that I can set up an environment I'm familiar and comfortable with in a matter of seconds, no matter what machine I'm using.

These files have been specifically tailored to fit my personal use-case (Go/JS/Python + Neovim).

I highly encourage you to develop your own config files that you are most comfortable with. However, if you find these files to be useful to you, feel free to use them in whatever way you see fit.

# Usage

## Windows
1. `git clone https://github.com/33313/.dotfiles.git $HOME/.config`
2. Run any install scripts if applicable.
3. Done!

## Ubuntu
1. `git clone -b ubuntu https://github.com/33313/.dotfiles.git ~/.config`
2. `chmod +x ~/.config/install.sh && ~/.config/install.sh`
3. Done!

# Structure
The `main` branch is designed to run on Windows 10.

Every other branch is named after the OS it's designed to run on, e.g. `ubuntu`.
