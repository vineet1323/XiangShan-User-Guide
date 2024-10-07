
sudo apt-get install -y pandoc librsvg2-bin

wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
tlmgr install ctex setspace

mkdir -p ~/.local/share/fonts
wget -O ~/.local/share/fonts/SourceHanSansCN-Regular.otf https://github.com/adobe-fonts/source-han-sans/raw/refs/heads/release/SubsetOTF/CN/SourceHanSansCN-Regular.otf
