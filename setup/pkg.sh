#!/usr/bin/env bash
# shellcheck disable=SC2312

set -euo pipefail

# ---- Detect distribution ----

if [[ ! -r /etc/os-release ]]; then
    echo "Cannot identify the Linux distribution."
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

DISTRO="${ID,,}"
ID_LIKE="${ID_LIKE:-}"
PM=""

case "$DISTRO" in
    ubuntu|debian|linuxmint|pop)
        PM="apt"
        ;;

    fedora|rhel|centos|rocky|almalinux)
        PM="dnf"
        ;;

    arch|manjaro|endeavouros)
        PM="pacman"
        ;;

    opensuse*|sles)
        PM="zypper"
        ;;

    alpine)
        PM="apk"
        ;;

    *)
        case "$ID_LIKE" in
            *debian*) PM="apt" ;;
            *fedora*|*rhel*) PM="dnf" ;;
            *arch*) PM="pacman" ;;
            *suse*) PM="zypper" ;;
            *)
                echo "Unsupported distribution: $ID"
                exit 1
                ;;
        esac
        ;;
esac

echo "Detected: ${PRETTY_NAME:-$DISTRO}"
echo "Package manager: $PM"

# ---- Privilege handling ----

if [[ $EUID -eq 0 ]]; then
    SUDO=()
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "This script requires sudo."
        exit 1
    fi
    SUDO=(sudo)
fi

install_packages() {
    if [[ $# -eq 0 ]]; then
        return 0
    fi

    case "$PM" in
        apt)
            "${SUDO[@]}" apt-get install -y "$@"
            ;;

        dnf)
            "${SUDO[@]}" dnf install -y "$@"
            ;;

        pacman)
            "${SUDO[@]}" pacman -S --needed --noconfirm "$@"
            ;;

        zypper)
            "${SUDO[@]}" zypper --non-interactive install "$@"
            ;;

        apk)
            "${SUDO[@]}" apk add "$@"
            ;;
    esac
}

enable_service() {
    local service="$1"

    if command -v systemctl >/dev/null 2>&1; then
        "${SUDO[@]}" systemctl enable --now "$service"
    elif command -v rc-service >/dev/null 2>&1; then
        "${SUDO[@]}" rc-update add "$service" default || true
        "${SUDO[@]}" rc-service "$service" start || true
    else
        echo "Could not configure service: $service"
    fi
}

# ---- Update package metadata/system ----

case "$PM" in
    apt)
        "${SUDO[@]}" apt-get update
        ;;

    dnf)
        "${SUDO[@]}" dnf upgrade -y
        ;;

    pacman)
        "${SUDO[@]}" pacman -Syu --noconfirm
        ;;

    zypper)
        "${SUDO[@]}" zypper --non-interactive refresh
        "${SUDO[@]}" zypper --non-interactive update
        ;;

    apk)
        "${SUDO[@]}" apk update
        ;;
esac

# ---- General packages ----

case "$PM" in
    apt)
        install_packages \
            autojump \
            curl \
            file \
            flatpak \
            gcc \
            git \
            gnome-tweaks \
            gnupg \
            htop \
            jq \
            procps \
            ripgrep \
            rsync \
            shellcheck \
            tmux \
            tree \
            unzip \
            vim-gtk \
            wget
        ;;

    dnf)
        install_packages \
            autojump \
            curl \
            file \
            flatpak \
            gcc \
            git \
            gnome-tweaks \
            gnupg2 \
            htop \
            jq \
            procps-ng \
            ripgrep \
            rsync \
            ShellCheck \
            tmux \
            tree \
            unzip \
            vim-enhanced \
            wget
        ;;

    pacman)
        install_packages \
            autojump \
            curl \
            file \
            flatpak \
            gcc \
            git \
            gnome-tweaks \
            gnupg \
            gvim \
            htop \
            jq \
            procps-ng \
            ripgrep \
            rsync \
            shellcheck \
            tmux \
            tree \
            unzip \
            vim \
            wget
        ;;

    zypper)
        install_packages \
            autojump \
            curl \
            file \
            flatpak \
            gcc \
            git \
            gnome-tweaks \
            gpg2 \
            htop \
            jq \
            procps \
            ripgrep \
            rsync \
            ShellCheck \
            tmux \
            tree \
            unzip \
            vim \
            wget
        ;;

    apk)
        install_packages \
            autojump \
            curl \
            file \
            flatpak \
            gcc \
            git \
            gnupg \
            htop \
            jq \
            linux-tools \
            musl-dev \
            procps \
            ripgrep \
            rsync \
            shellcheck \
            tmux \
            tree \
            unzip \
            vim \
            wget
        ;;
esac

# ---- Build dependencies ----

case "$PM" in
    apt)
        install_packages \
            autoconf \
            bison \
            build-essential \
            libbz2-dev \
            libdb-dev \
            libffi-dev \
            libgdbm-dev \
            liblzma-dev \
            libncurses-dev \
            libreadline-dev \
            libsqlite3-dev \
            libssl-dev \
            libxml2-dev \
            libxmlsec1-dev \
            libyaml-dev \
            llvm \
            make \
            python3-dev \
            python3-pip \
            python3-setuptools \
            tk-dev \
            xz-utils \
            zlib1g-dev
        ;;

    dnf)
        install_packages \
            autoconf \
            bison \
            bzip2-devel \
            db4-devel \
            file \
            gcc-c++ \
            gdbm-devel \
            libffi-devel \
            libxml2-devel \
            libyaml-devel \
            llvm \
            make \
            ncurses-devel \
            openssl-devel \
            readline-devel \
            sqlite-devel \
            tk-devel \
            xz-devel \
            zlib-devel \
            python3-devel \
            python3-pip \
            python3-setuptools \
            xmlsec1-devel
        ;;

    pacman)
        install_packages \
            autoconf \
            bison \
            base-devel \
            bzip2 \
            db \
            gdbm \
            libffi \
            libxml2 \
            libyaml \
            llvm \
            ncurses \
            openssl \
            readline \
            sqlite \
            tk \
            xz \
            xmlsec \
            zlib \
            python \
            python-pip \
            python-setuptools
        ;;

    zypper)
        install_packages \
            autoconf \
            bison \
            gcc-c++ \
            libbz2-devel \
            libdb-4_8-devel \
            libffi-devel \
            libgdbm-devel \
            liblzma-devel \
            libncurses6-devel \
            libreadline-devel \
            libsqlite3-0 \
            libopenssl-devel \
            libxml2-devel \
            libxmlsec1-devel \
            libyaml-devel \
            llvm \
            make \
            python3-devel \
            python3-pip \
            python3-setuptools \
            tk-devel \
            xz \
            zlib-devel
        ;;

    apk)
        install_packages \
            autoconf \
            bash \
            bison \
            build-base \
            bzip2-dev \
            db-dev \
            gdbm-dev \
            libffi-dev \
            libxml2-dev \
            libxmlsec1-dev \
            libyaml-dev \
            llvm \
            ncurses-dev \
            openssl-dev \
            readline-dev \
            sqlite-dev \
            tk-dev \
            xz-dev \
            zlib-dev \
            python3-dev \
            py3-pip
        ;;
esac

# ---- Flatpak ----

if command -v flatpak >/dev/null 2>&1; then
    "${SUDO[@]}" flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo || true
fi

# ---- Python tooling ----

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ---- PostgreSQL ----

case "$PM" in
    apt|dnf|zypper)
        install_packages postgresql postgresql-contrib
        ;;

    pacman)
        install_packages postgresql
        ;;

    apk)
        install_packages postgresql postgresql-contrib
        ;;
esac

# PostgreSQL initialization differs between distributions.
case "$PM" in
    apt)
        enable_service postgresql
        ;;

    dnf|zypper)
        if command -v postgresql-setup >/dev/null 2>&1; then
            "${SUDO[@]}" postgresql-setup --initdb || true
        fi
        enable_service postgresql
        ;;

    pacman)
        if [[ ! -d /var/lib/postgres/data/base ]]; then
            "${SUDO[@]}" -iu postgres initdb \
                --locale="${LANG:-C}" \
                -D /var/lib/postgres/data
        fi
        enable_service postgresql
        ;;

    apk)
        if [[ ! -d /var/lib/postgresql/data/base ]]; then
            "${SUDO[@]}" install -d -o postgres -g postgres \
                /var/lib/postgresql/data
            "${SUDO[@]}" -u postgres initdb \
                -D /var/lib/postgresql/data
        fi
        enable_service postgresql
        ;;
esac

# ---- Node.js and npm ----

case "$PM" in
    apt|dnf|pacman|zypper)
        install_packages nodejs npm
        ;;

    apk)
        install_packages nodejs npm
        ;;
esac

# The distro package provides the current/default Node.js version.
# For an exact major version, use a version manager such as mise, fnm, or nvm.

# ---- FZF ----

if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --all

# ---- lsd ----

case "$PM" in
    apt|dnf|pacman|zypper)
        install_packages lsd
        ;;

    apk)
        # lsd may not be available in every Alpine repository.
        if ! command -v lsd >/dev/null 2>&1; then
            echo "Skipping lsd: it is not available in the configured Alpine repositories."
        fi
        ;;
esac

# ---- Unsupported/optional packages ----

cat <<'EOF'

Optional packages not installed automatically:

- snapd:
    Usually unavailable or discouraged outside Ubuntu/Debian.
    Prefer Flatpak, the distro package manager, or the AUR.

- MongoDB:
    Usually requires an external repository or the AUR.
    Install it separately for your distribution.

- Exact Node.js 24:
    The distro package manager installs its current/default Node.js version.
    Use mise, fnm, or nvm if an exact Node.js version is required.

EOF

# ---- Cleanup ----

case "$PM" in
    apt)
        "${SUDO[@]}" apt-get autoremove -y
        "${SUDO[@]}" apt-get clean
        ;;

    dnf)
        "${SUDO[@]}" dnf autoremove -y
        "${SUDO[@]}" dnf clean all
        ;;

    pacman)
        "${SUDO[@]}" pacman -Sc --noconfirm
        ;;

    zypper)
        "${SUDO[@]}" zypper clean --all
        ;;

    apk)
        # APK has no direct equivalent of apt autoremove.
        "${SUDO[@]}" apk cache clean || true
        ;;
esac

echo "Installation complete."
