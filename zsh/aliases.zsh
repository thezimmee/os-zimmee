# aliases.zsh
# -----------
# @description All aliases should go here.

# [[[ OS Zimmee

# Command to run OSZ update script.
alias update="source ${OSZ_ROOT}/update"

# reload zsh
alias reload="source ~/.zshrc"

# ]]]

# [[[ Python
# @TODO: Move this to python/install.
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
# ]]]

# [[[ Marqeta

# function fds {
#   ENV="${1:-qa}"
#   echo "Running FDS API $ENV..."
#   cd ~/Projects/marqeta/horizon/experimental/fds
#   echo "Copying $ENV properties file, you may be asked to enter your password since sudo permissions are required..."
#   sudo cp /etc/dbsecrets/properties-"$ENV" /etc/dbsecrets/properties
#   sudo cp /etc/dbconfig/properties-"$ENV" /etc/dbconfig/properties
#   mvn clean install -DskipTests=true && java -Dapplication.env="$ENV" -jar fds-api/fds-api-v1/fds-api-v1-impl/target/fds-api-v1-impl-PINNED.jar
# }

# ]]]
