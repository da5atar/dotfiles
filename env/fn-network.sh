#!/usr/bin/env bash
# shellcheck disable=SC2312

#--- Network

# TODO 7: Refactor netinfo fn
# # Show current network information
# netinfo() { # TODO 5: Refactor to work on MAC
#   echo "--------------- Network Information ---------------"
#   /sbin/ifconfig | awk /'inet addr/ {print $2}'
#   echo ""
#   /sbin/ifconfig | awk /'Bcast/ {print $3}'
#   echo ""
#   /sbin/ifconfig | awk /'inet addr/ {print $4}'

#   /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#   echo "---------------------------------------------------"
# }

# TODO 8: Refactor whatismyip fn
# IP address lookup
# alias whatismyip="whatsmyip"
# function whatsmyip() {
#   # Dumps a list of all IP addresses for every device
#   # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

#   # Internal IP Lookup
#   echo -n "Internal IP: "
#   /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

#   # External IP Lookup
#   echo -n "External IP: "
#   wget http://smart-ip.net/myip -O - -q
# }

# View Apache logs
apachelog() {
    if [[ -f /etc/httpd/conf/httpd.conf ]]; then
        cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
    else
        cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
    fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
    if [[ -z "${1}" ]]; then
        echo "ERROR: No domain specified."
        return 1
    fi

    local domain="${1}"
    echo "Testing ${domain}…"
    echo "" # newline

    local tmp
    tmp=$(echo -e "GET / HTTP/1.0\nEOT" |
        openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText
        certText=$(echo "${tmp}" |
            openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version")
        echo "Common Name:"
        echo "" # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
        echo "" # newline
        echo "Subject Alternative Name(s):"
        echo "" # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
            sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
        return 0
    else
        echo "ERROR: Certificate not found."
        return 1
    fi
}

# TODO 9: Refactor for python3
# Start an HTTP server from a directory, optionally specifying the port
# function server() {
#   local port="${1:-8000}"
#   sleep 1 && open "http://localhost:${port}/" &
#   # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
#   # And serve everything as UTF-8 (although not technically correct, this doesn't break anything for binary files)
#   python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
# }

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
# function phpserver() {
# 	local port="${1:-4000}";
# 	local ip=$(ipconfig getifaddr en1);
# 	sleep 1 && open "http://${ip}:${port}/" &
# 	php -S "${ip}:${port}";
# }
