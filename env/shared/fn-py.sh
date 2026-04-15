# d_activate: deactivate virtual envs if active
function d_activate() {
  if [ -n "$PYENV_VIRTUAL_ENV" ]; then
    source deactivate
  elif [ -n "$VIRTUAL_ENV" ]; then
    deactivate
  fi
}

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
