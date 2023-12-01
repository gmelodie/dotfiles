TAG_VERSION=$(curl -s -I https://github.com/obsidianmd/obsidian-releases/releases/latest | grep -i location | cut -d "/" -f 8 | cut -d "v" -f 2 | tr -d '\r')
DOWNLOAD_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${TAG_VERSION}/obsidian_${TAG_VERSION}_amd64.snap"

wget -P "$HOME/Downloads" $DOWNLOAD_URL

sudo pkill -9 obsidian
sudo snap install "$HOME/Downloads/obsidian_${TAG_VERSION}_amd64.snap" --dangerous --classic
