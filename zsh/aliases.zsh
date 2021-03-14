# aliases.zsh
# -----------
# @description All aliases should go here.

# [[[ OS Zimmee

# Command to run OSZ update script.
alias update="source ${OSZ_ROOT}/update"

# reload zsh
alias reload="source ~/.zshrc"

# ]]]

# [[[ Marqeta
# @TODO: Move this to a Marqeta folder.

function fds {
  ENV="${1:-qa}"
  echo "Running FDS API $ENV..."
  cd ~/Projects/marqeta/horizon/experimental/fds
  echo "Copying $ENV properties file, you may be asked to enter your password since sudo permissions are required..."
  sudo cp /etc/dbsecrets/properties-"$ENV" /etc/dbsecrets/properties
  sudo cp /etc/dbconfig/properties-"$ENV" /etc/dbconfig/properties
  mvn clean install -DskipTests=true && java -Dapplication.env="$ENV" -jar fds-api/fds-api-v1/fds-api-v1-impl/target/fds-api-v1-impl-PINNED.jar
}

# ]]]
