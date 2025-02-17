# Jack's Scratchpad

### Git Branch in Terminal.

`$ sudo nano ~/.bashrc`

``` python
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[01;00m\]$ '
```

`$ source ~/.bashrc`

Change Log:
- 2025/01/22 - remove hostname and fixed word-wrap overflow issue

### List (ls) with Numeric Permissions (600, 755, etc)
``` python
alias cls="ls -l | awk   '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\"%0o \",k);print}'"
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

### VSCode Extensions
- SQLite
- Pylint
- Pylance
- Black Formatter
- Flake8
- Ruff
- Remote Explorer
