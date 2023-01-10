#!/bin/bash

# Set permissions
echo "Setting npm permissions"
sudo chown -R $USER:$(id -gn $USER) $HOME/.config

# Install commonly used clis
echo "Downloading npm clis"

# sudo npm i -g fast-cli # FIX 3 Error with Pupeeter
sudo npm i -g fkill-cli
sudo npm i -g http-server
sudo npm i -g npm-check
sudo npm i -g standard
sudo npm i -g svgo
sudo npm i -g trash-cli
sudo npm i -g wikit       # Wikipedia summaries in the terminal
sudo npm i docsify-cli -g # https://github.com/docsifyjs/docsify/
sudo npm i -g yarn        # https://classic.yarnpkg.com/en/docs/install/#debian-stable

# News
# https://www.npmjs.com/package/newsroom-cli
sudo npm i -g newsroom-cli
# https://github.com/shogunpurple/clinews
# Go to https://newsapi.org/register URL and register a free account to get the API key.
sudo npm i -g clinews
