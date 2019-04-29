# .bashrc
FACE="(ಠ益ಠ)"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo "${green} _                _          _ _ "
echo "| | ___   _   ___| |__   ___| | |"
echo "| |/ / | | | / __| '_ \ / _ \ | |"
echo "|   <| |_| | \__ \ | | |  __/ | |"
echo "|_|\__\__, | |___/_| |_|\___|_|_|"
echo "      |___/ ${red}        (ಠ益ಠ) < kill your shell ${reset}"

echo "${red}Functions and Aliases${reset}"


# Function used for getting alias and function names

echo -e "${green}pushit \t\t${reset}creates a PR and can merge branch to master"
echo -e "${green}login \t\t${reset}launches the azure cli login tool"
echo -e "${green}pipeline \t${reset}(needs to be logged into root acocunt) shows LZ pipeline"
echo -e "${green}killme \t\t${reset}kills all active AWS sessions in the environment variables"
echo -e "${green}venv \t\t${reset}launches a virtual environment wrapper"
echo -e "${green}upload \t\t${reset}adds all changes to git and commits them to the current branch"

# This  kills all active AWS sessions in your environment variables
function killme () {
    for i in $(export | grep AWS_ | sed 's/declare -x //g' | sed 's/=.*$//'); do
        echo "Unsetting $i"
        unset $i;
    done
}
# Function creates a new virtual env so you can work on lambdas and forget about dependency issues
function venv () {
    if [ $# -eq 0 ]
    then
        printf "usage:\n\t venv [name_of_env]\n\n"
        echo "Please Retry"
        exit
    fi
    
    FWD=`pwd`/$1
    echo "Launching $FWD"
    /c/Users/ngetty/AppData/Local/Programs/Python/Python37/Scripts/virtualenv $FWD
    source $FWD/Scripts/activate
    cd $FWD
    read -p "Would you like to develop lambdas? [Y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        /c/Users/ngetty/AppData/Local/Programs/Python/Python37/Scripts/pip install python-lambda
        # Download python-lambda readme
        /mingw64/bin/curl https://github.com/nficano/python-lambda/blob/master/README.md --output $FWD/README.md
        lambda init
    fi
    echo "We are now able to start developing. :D"
}

# Function will add and commit all code based of the message you pass it
# usage: upload "This is my message"
function upload () {
    echo "Commiting all changes to $(git branch | grep \* | cut -d ' ' -f2)"
    git add -A
    MESSAGE=$1
    DATE=$(date)
    msg="Automed Commit: $MESSAGE - $DATE"
    echo "Commit message" $msg
    git commit -m '$msg'
    git push
}


# User for CLI bar
PROMPT_COMMAND="__git_ps1"

export PS1="\[\033[32m $FACE \[\033[33m\]\W\[\033[36m\]\n  └───➤  \[\033[0m\] "

# Local Variables
export PATH=$PATH:/c/Users/ngetty/.npm-global:/c/Users/ngetty/AppData/Roaming/Python/Python37/Scripts:/c/users/ngetty/appdata/local/programs/python/python37/scripts
export HOME='/c/users/ngetty'

###########
# Aliases #
###########

# This will create a pull request and merge the code to the master branch
alias pushit='python ~/.personal/scripts/dev-push.py'

# this makes your LS look pretty
alias ll='ls -l --colo=auto'

# Allows you to use JQ
alias jq='/c/Users/ngetty/Downloads/jq-win64.exe'

# Quick Azure login
alias login='aws-azure-login'

# Prints the Lz pipeline
alias pipeline='python ~/.personal/scripts/pipeline.py '

# quick for git commit
alias gc='git commit -m '
