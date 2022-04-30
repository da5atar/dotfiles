#!usr/bin/env bash

# local exports too specific for being shared on all machines

# Cyberghost VPN

## VPN status

alias vpn='cyberghostvpn'
alias vpn-stat='cyberghostvpn --status'

## Connect

### List traffic servers
alias vpn-traffic-list-country='cyberghostvpn --traffic --country-code'

### List traffic servers - Just US
alias vpn-traffic-list-us='sudo cyberghostvpn --traffic --country-code US'

### Quick connect US
alias vpn-traffic-connect-us='sudo cyberghostvpn --traffic --country-code US --connect
'
### Quick connect DE
alias vpn-traffic-connect-de='sudo cyberghostvpn --traffic --country-code DE --connect'

### List New York servers
alias vpn-traffic-connect-nyc='sudo cyberghostvpn --traffic --country-code US --city "New York"'

### List Miami servers
alias vpn-traffic-connect-nyc='sudo cyberghostvpn --traffic --country-code US --city "Miami"'

## Stream

### Fetch streaming servers
alias vpn-stream-list-country='cyberghostvpn --streaming --country-code'

### Quick connect streaming Netflix US
alias vpn-stream-connect-nf-us="sudo cyberghostvpn --streaming 'Netflix US' --country-code US --connect"

## Torrent

### Fetch torrent countries

alias vpn-torrent-list='cyberghostvpn --torrent --country-code'

### Connect to torrent countries

### US
alias vpn-torrent-connect-us='sudo cyberghostvpn --torrent --country-code US --connect'
