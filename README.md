# table-tune-docker
General setup for table-tune app

# table-tune

# Pre-install steps
Make sure you have linux system like Ubuntu or any other.

If not you can use WSL for windows and install sub-system like Ubuntu.

WSL

Install:

Open PowerShell as Administrator and run the following commands:

1. wsl --install -> This will install both WSL 2 and Ubuntu
2. IF NOT than - wsl --install Ubuntu-24.04 -> current version
3. wsl --set-default-version 2 -> update to version 2
4. wsl --list --verbose -> After installation, verify that WSL 2 is installed by running

You should see something like:

NAME * Ubuntu
STATE *Running
VERSION *2

Check: wsl -l -v

This will list all installed WSL distributions. If Ubuntu is installed correctly, it should appear in the list.

(Maybe need to restart pc to apply changes)

Once done search for Ubuntu in start menu

# GITHUB
Make sure your git is installed and github profile is setup and ready to be used.

# Docker

Make sure you have a docker with compose

Follow the instructions to install:
    https://docs.docker.com/engine/install/ubuntu/

Verify installation:

docker --version
docker-compose --version

Check if your user has docker permissions:
groups or id -nG

Check docker daemon status (To check if the Docker service is running and if permissions are set correctly):
sudo service docker status

or for WSL:
sudo service docker status

Check docker permissions on unix socket:
ls -l /var/run/docker.sock => output should look like: srw-rw---- 1 root docker 0 Mar 9 10:30 /var/run/docker.sock
It means only root and users in the docker group can access it.

Check user permissions on docker executable:
ls -l $(which docker)
This will show the permissions of the Docker binary.

OR shorter:

Open Ubuntu terminal and run:

sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg

Now, add Docker’s official GPG key and repository:

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

Now, install Docker:

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

After installation, start Docker and allow your user (someUser) to use it without sudo:

sudo service docker start
sudo usermod -aG docker $USER

Restart WSL instance:

exit
wsl --shutdown

Reopen Ubuntu terminal nad verify docker works:

docker --version
docker run hello-world

# Init table-tune

1. Clone this repo
2. Go to repo root directory
3. Run docker-compose up --build (add the -d flag if you want to run it in detached mode and prevent output from displaying)
