# Jack's Scratchpad

### Git Branch in Terminal.

`$ sudo nano ~/.bashrc`

``` cpp
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\033[00m\]$ '
```

`$ source ~/.bashrc`

### Docker
``` Markdown
# Helpful Docker Commands
docker image -ls
docker image -rm <image_name>
docker ps -a
docker start <docker_id>
docker stop <docker_id>
docker remove <docker_id>

# Stop/Remove All Docker Containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```


### VSCode Extensions
- SQLite
- Pylint
- Pylance
- Black Formatter
- Flake8
- Ruff
- Remote Explorer
