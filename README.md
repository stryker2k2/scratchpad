# BBOT-FE Installation Guide
To get the bbot front end set up as it exists currently, you'll need to configure two machines, one for the server and one for the agent. These instructions assume you're using ubuntu VMs on BLS's network

### Connect to the Server
Connect to the server via SSH (or VMWare, VBox, or Proxmox Viewer)

### Install Packages
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


### Config Wireguard
``` Bash
# You'll use these keys, along with those from the agent's VM to configure wireguard.
# Return to this spot once you've generated keys on the agent's VM
wg genkey | tee privatekey | wg pubkey > publickey
```

sudo vim /etc/wireguard/wg0.conf
# insert the following, but replace the two key values and ip address:


[Interface]
PrivateKey = <server's private key>
Address = 10.0.1.4/24

[Peer]
PublicKey = <agent's public key>
Endpoint = <agent's public ip address>:51820
AllowedIPs = 10.0.1.0/24
PersistentKeepalive = 30

# ----------------------
# clone bbot-gui ---------------------------------------------------------------------
# ----------------------

gh auth login 
# follow instructions to login
# *must have access to blacklanternsecurity/bbot-gui repo 
# **optionally you could install git and login with your github creds instead, then use git clone git@github.com:blacklanternsecurity/bbot-gui.git

mkdir ~/source/
cd ~/source/
gh repo clone blacklanternsecurity/bbot-gui

# ----------------------
# config django ----------------------------------------------------------------------
# ----------------------

# in bbot-gui/django/Dockerfile, if you want to use the bbot stable release, remove the "--pre" from the following line:

&& pip3 install bbot --pre                      

# *make sure to use stable on the bbot agent if you're using stable here

# update django/api/settings.py
	# in ALLOWED_HOSTS, add new domain name (i.e. bbot-dev.blacklanernsecurity.com)
	# in MICROSOFT-> "app_id" and "app_secret" need to be updated with values from the azure portal. a new app registration has to be made by IT (Zach has this documented) and can provide these values
	# in MICROSOFT-> "redirect", use "<domain name>/microsoft_authentication/callback" (i.e https://bbot-dev.blacklanternsecurity.com/microsoft_authentication/callback)
	# in MICROSOFT-> "logout_uri", use "<domain name>/admin/logout" (i.e. https://bbot-dev.blacklanternsecurity.com/admin/logout)

# ----------------------
# setup react ------------------------------------------------------------------------
# ----------------------

cd ~/source/bbot-gui/react
mkdir node_modules
yarn install

# ----------------------
# install ssl cert--------------------------------------------------------------------
# ----------------------

# IT can provide ssl files for the server
mv <certificate and key files> ~/sources/bbot-gui/nginx/ssl/

# update the filenames in the following lines in ~/sources/bbot-gui/nginx/ssl/nginx.conf
    ssl_certificate /etc/nginx/ssl/<cert filename>;
    ssl_certificate_key /etc/nginx/ssl/<key filename>;

# ----------------------
# start/config server ----------------------------------------------------------------
# ----------------------

cd ~/source/bbot-gui/
sudo docker-compose up
# once that starts up, open another console window
# ssh to same machine/user
cd ~/source/bbot-gui/
sudo docker-compose exec django bash
python manage.py createsuperuser
# insert superuser info
# in a browser, go to "<domain name>/admin" (i.e. https://bbot-dev.blacklanternsecurity.com/admin)
# login with the superuser creds
# go to "<domain name>/api/agents"
# give the bbot agent you'll be using a name and click POST
# go to "<domain name>/api/campaigns"
# for campaign name, use the name of the customer (i.e. "GPC"). *also* make sure to click the name of the bbot agent in the next box before clicking POST
# go back to "<domain name>/admin" and click "+Add" next to "Tokens"
# select the name of your bbot agent in the drop down menu next to "User" and click "Save"
# copy the key value. this will go in the secrets.yml file for your bbot agent

# ----------------------
# config bbot agent ------------------------------------------------------------------
# ----------------------

# ssh to where you'll house the bbot agent
sudo apt update
sudo apt-get install -y docker tmux wireguard

wg genkey | tee privatekey | wg pubkey > publickey
# you'll need these keys and the keys from the server VM
sudo vim /etc/wireguard/wg0.conf
# paste in the following:

[Interface]
PrivateKey = <agent's private key>
Address = 10.0.1.3/24
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820

[Peer]
PublicKey = <server's public key>
AllowedIPs = 10.0.1.4/32

# then to start wireguard, run this command on both VMs
sudo wg-quick up wg0
# to test the connection, run the following command
sudo wg show wg0

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
