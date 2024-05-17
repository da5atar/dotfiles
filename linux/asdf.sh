#!/bin/bash
# Install ASDF (version manager which I use for non-Dockerized apps).
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

# Follow instructions here to source ASDF in your shell:
# https://asdf-vm.com/guide/getting-started.html#official-download

# Install Node through ASDF.
# asdf plugin-add nodejs
# bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
# asdf install nodejs 18.9.0
# asdf global nodejs 18.9.0

# Install Ruby through ASDF.
# asdf plugin-add ruby
# asdf install ruby 3.2.1
# asdf global ruby 3.2.1

# Install Go through ASDF.
# asdf plugin-add golang
# asdf install golang 1.20.2
# asdf global golang 1.20.2
