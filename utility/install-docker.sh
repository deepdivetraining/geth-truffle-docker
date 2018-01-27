# based on
# https://davekz.com/docker-on-lightsail/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
# https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04
sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
# check docker version/status from commandline
# apt-cache policy docker-ce
sudo apt-get install -y docker-ce

# check that docker is running ok
# sudo systemctl status docker

# make docker command run without sudo
sudo usermod -aG docker ${USER}
# not logout and login to activate or run
# su - ${USER}
# check from commandline that ubuntu user is in the user group
# id -nG

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# check version
# docker-compose --version
