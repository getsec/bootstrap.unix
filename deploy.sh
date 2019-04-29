# update dotfiles

set -a

home=$HOME
SCRIPT_DIR=$HOME/.personal


# Ensure script dir exists
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "$SCRIPT_DIR does not exist, creating"
fi


echo "Replacing BashRC"
cp bootstraps/.bashrc $HOME/.bashrc

echo "Home Dir: $HOME"

bash