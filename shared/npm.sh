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
