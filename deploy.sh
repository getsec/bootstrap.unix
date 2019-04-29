# update dotfiles

set -a

home=$HOME
SCRIPT_DIR=$HOME/.personal


# Ensure script dir exists
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "$SCRIPT_DIR does not exist, creating"
fi

# CHECKING FOR JQ
if [ ! -f "$SCRIPT_DIR/jq" ]; then
    echo "JQ was not found downloading now"
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe --output $SCRIPT_DIR/jq
fi

echo "Replacing BashRC"
cp bootstraps/.bashrc $HOME/.bashrc

echo "Home Dir: $HOME"