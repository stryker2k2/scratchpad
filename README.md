# Jack's Scratchpad

### New Ubuntu VM Must-Haves
``` bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install git tmux nano net-tools
```

### Github/Gitlab Cert
``` bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Git Branch in Terminal.

`$ sudo nano ~/.bashrc`

``` python
eval $(ssh-agent -s)
ssh-add ~/.ssh/<cert>

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PROMPT_COMMAND='branch=$(git branch 2>/dev/null | grep "^*" | cut -d" " -f2); if [ -n "$branch" ]; then PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h: \[\033[01;34m\]\w\[\033[01;31m\] ($branch)\[\033[01;00m\]\n$ "; else PS1="${debian_chroot:+($debian_chroo>
```

`$ source ~/.bashrc`

### List (ls) with Numeric Permissions (600, 755, etc)
``` python
alias cls="ls -l | awk   '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\"%0o \",k);print}'"
```

### Install Docker
``` bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update
sudo apt update

# Install Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add User to Docker Groups
sudo usermod -aG docker $USER
newgrp docker

# Test with Hello World Docker
sudo docker run hello-world
```

### Docker
``` Markdown
# Helpful Docker Commands
docker image -ls
docker image -rm <image_name>
docker ps -a
docker start <docker_id>
docker stop <docker_id>
docker remove <docker_id>

# Run and Start Docker Interactively
docker run -it <docker_image>
docker start -i <docker_id>
docker exec -it <docker_id> /bin/bash

# Stop/Remove All Docker Containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Remove All Docker Images
docker image rm $(docker image ls -a -q)

# View all Docker Volumes (and Remove All Volumes)
docker volume ls
docker volume rm $(docker volume ls -q)
```

### Docker Compose
``` Markdown
docker-compose exec <docker_name> bash
```

### Fix GitHub SSH Permission Error
``` Bash
# Linux
ssh-keygen -t ed25519 -C "name@email.com" # Create Key
eval $(ssh-agent -s) # Startup SSH Agent
ssh-add ~/.ssh/<cert> # Add Key
ssh-add -l # List Current Keys
cat <cert>.pub # Copy Public Key and the Paste into Github SSH Settings Page
```
``` Bash
# GitBash on Windows
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/<cert>
```
``` Powershell
# Windows (Terminal as Admin)
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add C:\Users\<user>\.ssh\<keyname>
```

Claude Code Settings (~/.claude/settings.json)
``` json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "WebFetch",
      "Read",
      "Find",
      "Bash(find:*)",
      "Bash(xargs:*)",
      "Bash(grep:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(objdump:*)",
      "Bash(wc:*)",
      "Bash(tail:*)",
      "Bash(head:*)"
    ]
  }
}
```
