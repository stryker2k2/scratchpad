# BBOT-FE Installation Guide
To get the bbot front end set up as it exists currently, you'll need to configure two machines, one for the server and one for the agent. These instructions assume you're using ubuntu VMs on BLS's network

## Connect to the Server
Connect to the server via SSH (or VMWare, VBox, or Proxmox Viewer)

## Install Packages
``` Bash
sudo apt-get update
sudo apt-get -y install curl gh docker-compose wireguard npm
sudo npm install -g n
sudo n stable
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn
```


## Config Wireguard
``` Bash
# You'll use these keys, along with those from the agent's VM to configure wireguard.
# Return to this spot once you've generated keys on the agent's VM
wg genkey | tee privatekey | wg pubkey > publickey

# Modify the wg0.conf with the two key values and ip address below:
sudo vim /etc/wireguard/wg0.conf
```

``` Python
[Interface]
PrivateKey = <server's private key>
Address = 10.0.1.4/24

[Peer]
PublicKey = <agent's public key>
Endpoint = <agent's public ip address>:51820
AllowedIPs = 10.0.1.0/24
PersistentKeepalive = 30
```


## Clone bbot-gui from GitHub using gh
You must have access to the Repo at github.com/blacklanternsecurity/bbot-gui

``` Bash
# Follow Instructions to Login with gh
gh auth login

# Create Source (or Repo) Folder then Clone Repo
mkdir ~/source/
cd ~/source/
gh repo clone blacklanternsecurity/bbot-gui
```

## Clone bbot-gui from GitHub using git (with Pre-Established SSH Credentials)

``` Bash
# Create Source (or Repo) Folder then Clone Repo
mkdir ~/source/
cd ~/source/
git clone git@github.com:blacklanternsecurity/bbot-gui.git
```


## Configure django

In bbot-gui/django/Dockerfile, if you want to use the bbot "stable" release, remove the "--pre" from the following line:\
*_Note: Ensure that you are using "stable" on the bbot agent if you're using stable here_*\
`&& pip3 install bbot --pre`

Modify these Settings in Django's API Settings:
``` Bash
# Open Django's API Settings (from /bbot-gui/)
sudo vim django/api/settings.py
```

``` Python
ALLOWED_HOSTS = [
    "...",
    "bbot-dev.blacklaternsecurity.com"
]

MICROSOFT = {
    "app_id": "update with values from Azure Portal",
    "app_secret": "update with values from Azure Portal",
    "redirect": "https://bbot-dev.blacklanternsecurity.com/microsoft_authentication/callback"
    "...",
    "logout_uri": "https://bbot-dev.blacklanternsecurity.com/admin/logout" 
} # Contact BLS IT for New App Registration Values
```


## Setup React

``` Bash
cd ~/source/bbot-gui/react
mkdir node_modules
yarn install
```


## Install SSL Cert

Contact BLS IT for SSL File for the Server then Move Certs inth NGINX's SSL Folder
``` Bash
mv <certificate and key files> ~/sources/bbot-gui/nginx/ssl/
```

Update the Filenames in the NGINX Conf File
``` Bash
# Open NGINX Conf File (from /bbot-gui/)
sudo vim nginx/ssl/nginx.conf
```
```
# update the filenames in the following lines in ~/sources/bbot-gui/nginx/ssl/nginx.conf
    ssl_certificate /etc/nginx/ssl/<cert filename>;
    ssl_certificate_key /etc/nginx/ssl/<key filename>;
```

## Configure and Start Server

``` Bash
# Terminal/Pane #1 (ssh into server)
cd ~/source/bbot-gui/
sudo docker-compose up

# Terminal/Pane #2 (ssh into server)
cd ~/source/bbot-gui/
sudo docker-compose exec django bash
python manage.py createsuperuser
```

Insert SuperUser Unfo
1. in a browser, go to "<domain name>/admin" (i.e. https://bbot-dev.blacklanternsecurity.com/admin)
1. login with the superuser creds
1. go to "<domain name>/api/agents"
1. give the bbot agent you'll be using a name and click POST
1. go to "<domain name>/api/campaigns"
1. for campaign name, use the name of the customer (i.e. "GPC"). *also* make sure to click the name of the bbot agent in the next box before clicking POST
1. go back to "<domain name>/admin" and click "+Add" next to "Tokens"
1. select the name of your bbot agent in the drop down menu next to "User" and click "Save"
1. copy the key value. this will go in the secrets.yml file for your bbot agent


# Config BBOT Agent

## Install Packages
``` Bash
# ssh into bbot agent machine
sudo apt update
sudo apt-get install -y docker tmux wireguard
```

## Configure Wireguard
``` Bash
# you'll need these keys and the keys from the server VM
wg genkey | tee privatekey | wg pubkey > publickey

sudo vim /etc/wireguard/wg0.conf
```

``` Python
[Interface]
PrivateKey = <agent's private key>
Address = 10.0.1.3/24
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820

[Peer]
PublicKey = <server's public key>
AllowedIPs = 10.0.1.4/32
```

## Start Wireguard (on WebServer AND BBOT Agent VMs)

``` Bash
# start wireguard (on both VMs)
sudo wg-quick up wg0

# run the following command to test the connection
sudo wg show wg0
```



tmux
sudo docker run --name bbot --entrypoint /bin/bash -it blacklanternsecurity/bbot:stable
# remove the :stable part if you installed the dev release on the server
bbot
bbot --install-all-deps

sudo vim ~/.config/bbot/bbot.yml

# uncomment and update: 
agent_url: 'ws://10.0.1.4/ws'

# uncomment and update:
output_modules:
    websocket:
        url: 'ws://10.0.1.4/ws'	

sudo vim ~/.config/bbot/secrets.yml
# uncomment and update agent_token. this will be the token that you generated on the front end in the django admin portal in your browser
# here you can also uncomment and paste in any API keys you want for BBOT modules you want to use

# now if everything is configured, wireguard has been started on both VMs, the server is still running (docker-compose up), you can use the following command to start the agent so you can run scans on the front end
bbot -a -d -v 

# you can close the terminal windows. the server and agent will keep running

# if you reconnect to the agent VM, you can get back into the docker with the following commands:
tmux
sudo docker start -i bbot
