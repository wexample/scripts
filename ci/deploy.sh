#!/bin/bash

# Add SSH and prevent host checking.
apt-get install openssh-client -yqq
apt-get install curl -yqq

echo "   > Load wexample.sh"
# Wexample loader for multiple scripts.
w=wexample.sh
curl https://raw.githubusercontent.com/wexample/scripts/master/bash/ubuntu-16.x/$w | tr -d '\015' > $w

echo "   > Load sshRemoveHostChecking.sh"
bash $w -s=sshRemoveHostChecking -rm

echo "   > ssh-add"
# Add ssh user.
ssh-add <(echo "$STAGING_PRIVATE_KEY")

echo "   > install git"
# Install git.
apt-get install git -yqq

# Remove warning on new SSH host.
bash $w -s=gitlabDeployGithub -rm -a="git@github.com:wexample/scripts.git"
