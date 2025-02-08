#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2230,SC2312

#--- Python

## Save python version output in a variable
pyversion() {
    _pyversion=$(${PYTHON} --version 2>&1) # needs redirect because defaults to stderr
    echo "${_pyversion}"
}

## Returns Python version with underscore
_add_underscore_pyversion() {
    pyv=$(pyversion)
    add_underscore "${pyv}"
}

### Print python info
py_info() {
    echo "${GREEN}Python Info: ${NOCOLOR}"
    printf "----\n"
    echo "${GREEN}Using: ${NOCOLOR}"
    which "${PYTHON}"
    echo "${GREEN}Version: ${NOCOLOR}"
    ${PYTHON} -V
    echo "${GREEN}with: ${NOCOLOR}"
    echo "=====>"
    _virtualenv_info
    echo "=====>"
    _virtualenvwrapper_info
    echo "${GREEN}and: ${NOCOLOR}"
    ${PYTHON} -m pip --version
    echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
    printf "=====\n"
}

### function to ensure python command is available
_set_python_alias() {
    # Set python alias if python command is not found
    if ! python --version &>/dev/null; then
        if python3 --version &>/dev/null; then
            export PYTHON="python3"
            alias python='$PYTHON'
        fi
    fi
}

## Virtualenv
_is_virtualenv() {
    if [[ -n "$(${PYTHON} -m virtualenv --version)" ]]; then
        echo "Virtualenv is installed for $(${PYTHON} -V 2>&1 | head -n 1)"
        return 0
    else
        echo "Virtualenv is not installed for this Python version"
        return 1
    fi
}

_virtualenv_info() {
    echo "${GREEN}Virtualenv Info: ${NOCOLOR}"
    ${PYTHON} -m pip show virtualenv | grep -e Version -e Location || echo "Virtualenv is not installed"
}

## Virtualenvwrapper
_is_virtualenvwrapper_installed() {
    if _virtualenvwrapper_info; then
        echo "Virtualenvwrapper is installed for $(${PYTHON} -V 2>&1 | head -n 1)"
        return 0
    else
        echo "Virtualenvwrapper is not installed for this Python version"
        return 1
    fi
}

_virtualenvwrapper_info() {
    echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
    ${PYTHON} -m pip show virtualenvwrapper | grep -e Version -e Location || echo "Virtualenvwrapper is not installed"
}

### virtualenvwrapper initializer
_init_virtualenvwrapper() { # modified 2023-01-21
    # if homebrew is installed
    if [[ -n "${HOMEBREW_PREFIX+x}" ]] && [[ -n "$(brew --prefix &>/dev/null)" ]]; then
        # Save Homebrew Python
        # See https://docs.brew.sh/Homebrew-and-Python
        HOMEBREW_PYTHON="$(brew --prefix)/opt/python/libexec/bin/python" # unversioned symlink for python
        HOMEBREW_PYTHON -m pip install virtualenvwrapper
        PYTHON=${HOMEBREW_PYTHON}
        export HOMEBREW_VIRTUALENV
        HOMEBREW_VIRTUALENV=$(brew --prefix)/bin/virtualenv
        VIRTUALENV=${HOMEBREW_VIRTUALENV}
        echo "Using Homebrew Python: ${HOMEBREW_PYTHON}"
        echo "Using Homebrew Virtualenv: ${HOMEBREW_VIRTUALENV}"

    elif [[ -n "${PYENV_ROOT}" ]] && [[ "$(pyenv version-name)" != 'system' ]]; then
        PYENV_PYTHON=$(pyenv which python)
        PYTHON=${PYENV_PYTHON}
        PYENV_VERSION=$(pyenv version-name)
        VIRTUALENV=$(pyenv which virtualenv)
        echo "Using pyenv Python: ${PYENV_PYTHON}"
        echo "Using pyenv Virtualenv: ${VIRTUALENV}"

    else
        PYTHON=${SYS_PYTHON}
        echo "Defaulting to system's Python: ${SYS_PYTHON}"
        echo "Use 'python -m venv <venv_name>' to create a virtual environment"
        return 1
    fi

    _set_virtualenvwrapper
    _init_pyenv_virtualenvwrapper

}

### Set virtualenvwrapper helper fn
_set_virtualenvwrapper() {
    WORKON_HOME=${VENV_FOLDER}/${HOSTNAME}"/$(_add_underscore_pyversion)"
    VIRTUALENVWRAPPER_PYTHON=${PYTHON}
    VIRTUALENVWRAPPER_VIRTUALENV=${VIRTUALENV}
    VIRTUALENVWRAPPER_SCRIPT_PREFIX="$(prefix "${VIRTUALENV}")"
    VIRTUALENVWRAPPER_SCRIPT="${VIRTUALENVWRAPPER_SCRIPT_PREFIX}/virtualenvwrapper.sh"
    export VIRTUALENVWRAPPER_PYTHON
    export VIRTUALENVWRAPPER_VIRTUALENV
}

# shellcheck disable=SC1091
### Source virtualenvwrapper.sh
_source_virtualenvwrapper() {
    if [[ -f "${VIRTUALENVWRAPPER_SCRIPT}" ]]; then
        # shellcheck source=path/to/virtualenvwrapper.sh
        source "${VIRTUALENVWRAPPER_SCRIPT}"
        echo "Successfully initialized virtualenvwrapper"
    else
        echo "virtualenvwrapper.sh not found"
    fi
}

## Pyenv helper functions :

# Initializes pyenv
### _init_pyenv()
_init_pyenv() {
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init --path)"
    fi
}

_init_pyenv_virtualenvwrapper() {
    echo "Initializing virtualenvwrapper with pyenv"
    # install pyenv-virtualenv if not found
    if ! _pyenv_virtualenv_installed &>/dev/null; then
        is_pyenv_virtualenvwrapper_installed ||
            _install_pyenv_virtualenvwrapper
    fi

    pyenv virtualenvwrapper &&
        echo "Done initializing virtualenvwrapper!" ||
        echo "Failed to initialize virtualenvwrapper" &&
        return 1
    printf "=====\n"
}

_pyenv_installed() {
    if [[ -d "${HOME}/.pyenv" ]]; then
        echo "Pyenv is installed"
        return 0
    else
        echo "Pyenv is not installed"
        return 1
    fi
}

_pyenv_virtualenv_installed() {
    if ! isEmpty "$(pyenv root)/plugins/pyenv-virtualenv"; then
        echo "Pyenv-virtualenv is installed"
        return 0
    else
        echo "Pyenv-virtualenv is not installed"
        return 1
    fi
}

## https://github.com/pyenv/pyenv-virtualenv
_install_pyenv_virtualenvwrapper() {
    echo "Installing pyenv-virtualenv and pyenv-virtualenvwrapper:"
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)"/plugins/pyenv-virtualenv
    git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$(pyenv root)"/plugins/pyenv-virtualenvwrapper # optional
}

is_pyenv_virtualenvwrapper_installed() {
    if [[ -d "$(pyenv root)/plugins/pyenv-virtualenvwrapper/bin/" ]]; then
        echo "pyenv-virtualenvwrapper is installed"
        return 0
    else
        echo "pyenv-virtualenvwrapper is not installed"
        return 1
    fi
}

_set_pyenv_python() {
    echo "Setting python to pyenv version: ${PYENV_VERSION}"
    pyenv shell "${PYENV_VERSION}"
    pyenv global "${PYENV_VERSION}"
    echo "Upgrading pip:" && ${PYENV_PYTHON} -m pip install --upgrade pip
    PYENV_PYTHON=$(pyenv which python)
    PYTHON=${PYENV_PYTHON}
    echo "Done."
    printf "=====\n"
}

# shellcheck disable=SC2153
# Set the Shell to latest Python2 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python2_latest() {
    PYENV_VERSION=${PYENV_VERSION_2}
    pyenv shell "${PYENV_VERSION}"
}

# shellcheck disable=SC2153
# Set the Shell to preferred Python3 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python3_base() {
    PYENV_VERSION=${PYENV_VERSION_3}
    pyenv shell "${PYENV_VERSION}"
}

# Set the Shell to latest Python3 from pyenv.
# This function requires https://github.com/momo-lab/pyenv-install-latest
python3_latest() {
    PYENV_VERSION_3_LATEST=$(pyenv install-latest -l | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
    # check if latest python version is installed with pyenv
    if pyenv versions | grep -q "${PYENV_VERSION_3_LATEST}"; then
        echo "Latest python version (${PYENV_VERSION_3_LATEST}) is already installed"
    else
        echo "Installing latest python version"
        pyenv install-latest "${PYENV_VERSION_3_LATEST}"
    fi
    PYENV_VERSION=${PYENV_VERSION_3_LATEST}
    pyenv shell "${PYENV_VERSION}"
}

# Set the Shell to the system Python
set_system_python() {
    pyenv global system
    pyenv shell system
    PYTHON=$(pyenv which python3)
    export PYTHON
}

pyenv_info() {
    # check if $PYENV_VERSION is set and if pyenv is installed
    if ! _pyenv_installed &>/dev/null; then
        echo "Seems that pyenv is not installed"
        return
    fi

    if [[ -n "${PYENV_PYTHON}" ]]; then
        echo "${GREEN}Pyenv Info: ${NOCOLOR}"
        printf "----\n"
        echo "${GREEN}Using: ${NOCOLOR}"
        echo "${PYENV_PYTHON}"
        echo "${GREEN}Version: ${NOCOLOR}"
        ${PYENV_PYTHON} --version
        echo "${GREEN}and: ${NOCOLOR}"
        ${PYENV_PYTHON} -m pip --version
        echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
    elif [[ "$(pyenv version-name)" =~ 'system' ]] && [[ -z "${PYENV_VERSION}" ]]; then
        echo "${GREEN}Using system python${NOCOLOR}"
        echo "PYENV_VERSION is not set"
        print "====>\n" && py_info
        printf "=====\n"
        return 2
    fi
    printf "=====\n"
}

# function to create a virtual environment with pyenv
# Usage: py_venv
# -- Echoes python and virtual environment related info
py_venv() {
    echo "Creating virtual python environment with pyenv"
    echo "Press 2 or 3 followed by the virtual environment name (optional) to select defaults"
    echo "Press 1 to use latest python"
    echo "Press s to choose from installed versions"
    echo "Press d to delete a virtual environment"
    echo "Press q to quit"
    # wait for input
    printf "Enter your choice: "
    read -r selection
    case ${selection} in
    1) printf "====>\n" && python3_latest || return 1 ;;
    2) printf "====>\n" && python2_latest || return 1 ;;
    3) printf "====>\n" && python3_base || return 1 ;;
    s | S) printf "====>\n" && _pyenv_version_selection || return 1 ;;
    d | D) printf "====>\n" && _delete_py_venv && return ;;
    q | Q) return ;;
    *) echo "invalid choice" && return 1 ;;
    esac

    # deactivate any running environment
    pyenv deactivate >/dev/null 2>&1 && deactivate >/dev/null 2>&1
    # Prompt user to continue creating virtual environment if selection is not s, d or q
    printf "Press y to create new virtual environment, n to continue without creating a new one \n"
    printf "or q to quit. Choice: "
    local new_venv
    read -r new_venv
    case ${new_venv} in
    y | Y)
        printf "---->\n"
        echo "Enter virtual environment name (optional): "
        local venv_name
        read -r venv_name

        if [[ -n "${venv_name}" ]]; then
            echo "Naming environment as: ${venv_name}"
        else # use default name
            echo "Using default name"
        fi
        printf "---->\n"
        echo "Enter project name (optional) - Enter to use the default name: (${venv_name})"
        local project_name
        read -r project_name

        if [[ -z "${project_name}" ]]; then
            project_name=${venv_name}
        else
            echo "project folder will be: '${project_name}'"
            echo "====>"
            goto_dir "${PROJECT_HOME}/${project_name}"
        fi

        # Create virtual environment
        if [[ "$(pyenv version-name)" =~ 'system' ]]; then
            printf "====>\n"
            _mkvenv "${venv_name}"
        else
            echo "Creating virtual environment with pyenv"
            _create_py_venv "$(pyenv version-name)" "${venv_name}"
        fi

        printf "====>\n"
        pyenv_info
        ;;
    n | N)
        echo "Not creating new virtual environment" &&
            if [[ "$(pyenv version-name)" =~ 'system' ]]; then
                echo "Using system-wide python" &&
                    printf "====>\n" && _set_python_alias && printf "====>\n" && py_info
            else
                echo "Using Python version: ${PYENV_VERSION} from pyenv"
                printf "====>\n" && pyenv_info
            fi
        ;;
    q | Q) echo "Exiting..." && return 0 ;;
    *) echo "Invalid choice" && return 1 ;;
    esac

    echo "Done!"
    printf "=====\n"
}

# function to list virtual environments
venv_list() {
    # Keep track of virtualenvs
    export virtualenvs=()
    export workons=()

    for version in $(pyenv versions --bare --skip-aliases); do
        virtualenvs+=("${version}")
    done

    for version in $(workon 2>/dev/null); do
        workons+=("${version}")
        virtualenvs+=("${version}")
    done
    # display array
    echo "${virtualenvs[@]}"
}

# pyenv version selection
_pyenv_version_selection() {

    venv_list >/dev/null 2>&1

    echo "There are ${#virtualenvs[*]} versions available."

    # Display the active version
    local current_version
    current_version=$(pyenv version-name)
    echo "Current version: ${current_version}"

    printf "Select version to use or 'q' to exit - 'c' to use current version. \n"
    PS3="Selection: "
    select version in "${virtualenvs[@]}"; do
        if [[ -n "${version}" ]]; then
            echo "You selected: ${version}"
            # check if the version is from an existing virtual environment
            if [[ " ${virtualenvs[*]} " =~ ${version} ]] && [[ "${version}" =~ "venv" ]]; then
                echo "This is an existing virtual environment. Activating..."
                if [[ " ${workons[*]} " =~ ${version} ]]; then
                    echo "Activating virtual environment with virtualenvwrapper"
                    workon "${version}" >/dev/null 2>&1
                    echo "To deactivate, run 'deactivate'"
                    printf "====>\n"
                else
                    echo "Activating virtual environment with pyenv"
                    pyenv activate "${version}" >/dev/null 2>&1
                    echo "To deactivate, run 'pyenv deactivate'"
                    printf "====>\n"
                fi
                pyenv_info
                printf "=====\n"
                return 2
            else
                PYENV_VERSION=${version}
                printf "====>\n"
                _set_pyenv_python
                echo "current Python version is now: ${PYENV_VERSION}" &&
                    break
            fi
        elif [[ "${REPLY}" = "q" ]]; then
            return 1
        # TODO detect if user pressed enter
        # for some reason, this is not working in a select loop
        # elif [ -z "$REPLY" ]; then
        #     echo "Using current version: $current_version"
        #     break
        elif [[ "${REPLY}" = "c" ]]; then
            echo "Keeping current version: ${current_version}" &&
                printf "====>\n" &&
                # setting python alias avoids funny behaviour of pyversion
                # when python command is not found in PATH
                _set_python_alias &&
                break
        else
            echo "Invalid option. Try another one - 'q': exit."
        fi
    done

    printf "=====\n"
}

# Redefines $WORKON_HOME to isolate virtual environments by python version:
### create_py_venv()
# This function takes two parameters:
# $1 is the python version for the environment (required)
# $2 is the name of the virtual environment (optional)
# Usage: _create_py_venv <python version> [<virtual environment name>]
# Example: _create_py_venv 3.8.6 [myvenv]
_create_py_venv() {
    PYENV_VERSION="$1"

    if [[ -n "$2" ]]; then
        venv_name="$2"
    else
        venv_name="test_$(_add_underscore_pyversion)"
    fi

    printf "---->\n"
    echo "Creating ${venv_name} environment with $(pyversion)"
    # Create and activate virtual environment
    venv_name="${venv_name}_venv"
    # choose between pyenv virtualenv or pyenv virtualenvwrapper
    printf "Use pyenv virtualenv (1), virtualenvwrapper (2), or Autoswitch (3)? "
    read -r choice
    case "${choice}" in
    1)
        echo "Using pyenv virtualenv"
        pyenv virtualenv "${PYENV_VERSION}" "${venv_name}"
        pyenv activate "${venv_name}"
        echo "To delete the virtual environment, run: pyenv uninstall ${venv_name}"
        echo "To deactivate the virtual environment, run: pyenv deactivate"
        printf "-----\n"
        ;;
    2)
        echo "Using virtualenvwrapper..."
        _init_pyenv_virtualenvwrapper
        printf "Virtual environments will be created using $(pyversion) in:\n '%s' \n" \
            "${WORKON_HOME}"
        printf "---->\n"
        printf "====>\n"
        mkvirtualenv "${venv_name}" &&
            workon "${venv_name}"
        echo "To delete the virtual environment, run: rmvirtualenv ${venv_name}"
        echo "To deactivate the virtual environment, run: deactivate"
        printf "-----\n"
        ;;
    3)
        echo "Using Autoswitch virtualenv"
        printf "---->\n"
        mkvenv "${venv_name}"
        echo "To delete the virtual environment, run: rmvenv"
        echo "To deactivate the virtual environment, run: deactivate"
        printf "-----\n"
        ;;
    *) echo "Invalid choice" && return 1 ;;
    esac

    echo "Done activating virtual environment: ${venv_name}."
    printf "=====\n"
}

# shellcheck disable=SC2120
# Delete a virtual environment created with pyenv
### _delete_py_venv()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: _delete_py_venv <virtual environment name>
# Example: _delete_py_venv myvenv
_delete_py_venv() {
    if [[ -n "$1" ]]; then
        venv_name="$1"
    else
        venv_list >/dev/null 2>&1
        echo "There are ${#virtualenvs[*]} versions available."

        # Display the active version
        local current_version
        current_version=$(pyenv version-name)
        echo "Current version: ${current_version}"

        printf "Select version to delete or 'q' to exit. \n"
        PS3="Selection: "
        select version in "${virtualenvs[@]}"; do
            if [[ -n "${version}" ]]; then
                echo "You selected: ${version}"
                if [[ " ${virtualenvs[*]} " =~ ${version} ]]; then
                    venv_name="${version}"
                    break
                else
                    echo "This is not a virtual environment. Try another one."
                fi
                break
            elif [[ "${REPLY}" = "q" ]]; then
                return 0
            else
                echo "Invalid option. Try another one - 'q': exit."
            fi
        done
    fi

    if [[ -z "${venv_name}" ]]; then
        echo "No virtual environment selected. Exiting."
        return 0
    else
        echo "Deleting virtual environment: ${venv_name}"
        pyenv uninstall "${venv_name}" || rmvirtualenv "${venv_name}"
    fi
}

# shellcheck disable=SC1091
# Usage: _mkvenv <virtual environment name>
_mkvenv() {
    if [[ -n "$1" ]]; then
        venv_name="$1"
    else
        venv_name="test_$(_add_underscore_pyversion)"
    fi

    printf "---->\n"
    venv_name="${venv_name}_venv"

    echo "Creating virtual environment with system-wide python"
    printf "====>\n"

    # Use virtualenvwrapper to create and activate virtual environment
    set_system_python
    if _is_virtualenvwrapper_installed; then
        _source_virtualenvwrapper &&
            mkvirtualenv "${venv_name}" && workon "${venv_name}"
        return 0
    else
        echo "Using standard libray venv module"
        ${PYTHON} -m venv "${venv_name}" && source "${venv_name}"/bin/activate && return 0 || return 1
    fi
    printf "=====\n"
}

### docker-py-env()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env [<virtual environment name>]
# Example: docker-py-env myvenv
docker-py-env() {
    echo "Creating python environment with docker"
    if [[ -n "$1" ]]; then
        goto_dir "${PROJECT_HOME}/$1"
    fi
    docker run --rm --name "$(slug "$(here)")" -it -v "$(here)_python-env":/usr/local/lib -v "${PWD}":/usr/src/app -w /usr/src/app python:latest bash
}

### docker-py3.8-env()
# This function takes one parameter:f
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env [<virtual environment name>]
# Example: docker-py-env myvenv
docker-py3.8-env() {
    echo "Creating python 3.8 environment with docker"
    if [[ -n "$1" ]]; then
        goto_dir "${PROJECT_HOME}/$1"
    fi
    docker run --rm --name "$(slug "$(here)")" -it -v "$(here)_python-env":/usr/local/lib -v "${PWD}":/usr/src/app -w /usr/src/app python:3.8 bash
}

### docker-py-env-del()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env-del [<virtual environment name>]
docker-py-env-del() {
    docker volume rm "$(here)_python-env"
}
