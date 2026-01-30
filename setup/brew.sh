#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2312

# Install Homebrew (if not installed)
echo "Installing Homebrew."

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Install GNU core utilities (those that come with macOS are outdated).
brew install coreutils
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# echo 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc

ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed` as gsed
brew install gnu-sed

# Install useful binaries.

brew install ack                         # text search tool
brew install autojump                    # Directory navigation tool
brew install atuin                       # shell history
brew install bat                         # cat alternative
brew install colima                      # container runtime
brew install docker                      # container runtime
brew install docker-compose              # container orchestration
brew install dust                        # Disk usage analyzer
brew install fabric-ai                   # AI framework
brew install fd                          # file finder
brew install gh                          # GitHub CLI
brew install git-ignore                  # git ignore file generator
brew install glib                        # library for computing the b2 hash
brew install glow                        # terminal markdown viewer
brew install libb2                       # library for computing the b2 hash
brew install lima-additional-guestagents # additional guest agents for Lima
brew install lsd                         # file listing
brew install lynis                       # security auditing tool
brew install node                        # JavaScript runtime
brew install ollama                      # LLM runner
brew install openssl@3                   # OpenSSL library
brew install pango                       # library for rendering text and images
brew install pipx                        # Python package manager
brew install pnpm                        # JavaScript package manager
brew install qemu                        # virtual machine emulator
brew install quarkdown                   # Markdown-based typesetting system
brew install ripgrep                     # fast regex search tool
brew install readline                    # command line editing library
brew install ripgrep                     # fast regex search tool
brew install ruby                        # Ruby programming language
brew install rust                        # Programming language
brew install sha3sum                     # hash function
brew install shellcheck                  # shell script linting tool
brew install shfmt                       # shell script formatter
brew install starship                    # cross-shell prompt
brew install task                        # Task runner
brew install tcl-tk@8                    # Tcl/Tk scripting language
brew install tealdeer                    # terminal documentation viewer
brew install television                  # file finder
brew install tgpt                        # AI Chatbots in terminal
brew install thefuck                     # Command correction tool
brew install tokei                       # Code statistics tool
brew install tree                        # directory listing tool
brew install trippy                      # Network diagnostic tool
brew install utm                         # system emulator and virtual machine host
brew install uv                          # python package manager
brew install virtualenv                  # python virtual environment manager
brew install weasyprint                  # HTML to PDF converter
brew install wget                        # download tool
brew install witr                        # Why is this running?
brew install xz                          # compression library
brew install yazi                        # Terminal file navigator
brew install yt-dlp                      # YouTube video downloader
brew install zoxide                      # Directory navigation tool
brew install zlib                        # compression library

# Installs Casks Fonts and preferred fonts

brew tap homebrew/cask-fonts
# Nerd Fonts
brew install font-3270-nerd-font
brew install font-hack-nerd-font
brew install font-firacode-nerd-font

# Casks

## Apps I use

brew install android-platform-tools # Android SDK Tools
brew install antigravity            # AI IDE
brew install apparency              # Inspect application bundles
brew install appcleaner             # Application uninstaller
brew install applite                # Homebrew GUI
brew install atuin-desktop          # Runbook editor for terminal workflows
brew install balenaetcher           # flash OS images
brew install bitwarden              # Password Manager
brew install brave-browser          # Web Browser
brew install browsers               # Web browser selection tool
brew install bruno                  # API testing tool
brew install calibre                # ebook management tool
brew install dropbox                # Cloud Storage
brew install duckduckgo             # Web browser
brew install duplicati              # backup tool
brew install figma                  # Design tool
brew install freeplane              # Mind mapping tool
brew install google-chrome          # Web browser
brew install google-drive           # Cloud Storage
brew install iterm2                 # Terminal Emulator
brew install jan                    # llm runner
brew install jordanbaird-ice@beta   # Menu bar customizer
brew install keepingyouawake        # Keep your Mac awake
brew install logseq                 # note-taking app
brew install lulu                   # firewall
brew install mark-text              # markdown editor (Deprecated, will be disabled on [[2026-09-01]])
brew install obsidian               # note-taking app
brew install openmtp                # Android file transfer
brew install pearcleaner            # App cleaner
brew install positron               # Data science IDE
brew install proton-mail            # email client
brew install slack                  # communication app
brew install spotify                # music streaming service
brew install stats                  # system monitoring tool
brew install swiftbar               # menu bar app
brew install vlc                    # media player
brew install void                   # ai code editor
brew install zed                    # ai code editor
brew install zoom                   # video conferencing app
brew install zotero                 # reference manager

# Remove outdated versions from the cellar.
brew cleanup
