#!/usr/bin/with-contenv bashio
# ==============================================================================

declare CONFIG
declare authentication_required
declare username
declare password
declare download_dir
declare incomplete_dir
declare incomplete_dir_enabled

if ! bashio::fs.directory_exists '/data/transmission'; then
  mkdir '/data/transmission'
fi

if ! bashio::fs.file_exists '/data/transmission/settings.json'; then
  echo "{}" > /data/transmission/settings.json
fi

CONFIG=$(</data/transmission/settings.json)

# Defaults
#CONFIG=$(bashio::jq "${CONFIG}" ".\"incomplete-dir\"=\"/share/incomplete\"")
#CONFIG=$(bashio::jq "${CONFIG}" ".\"incomplete-dir-enabled\"=true")
#CONFIG=$(bashio::jq "${CONFIG}" ".\"download-dir\"=\"/share/downloads\"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-whitelist-enabled\"=false")
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-host-whitelist-enabled\"=false")
CONFIG=$(bashio::jq "${CONFIG}" ".\"bind-address-ipv4\"=\"0.0.0.0\"")

authentication_required=$(bashio::config 'authentication_required')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-authentication-required\"=${authentication_required}")


download_dir=$(bashio::config 'download_dir')
CONFIG=$(bashio::jq "${CONFIG}" ".\"download-dir\"=\"${download_dir}\"")

incomplete_dir_enabled=$(bashio::config 'incomplete_dir_enabled')
CONFIG=$(bashio::jq "${CONFIG}" ".\"incomplete-dir-enabled\"=\"${incomplete_dir_enabled}\"")

incomplete_dir_enabled=$(bashio::config 'incomplete_dir')
CONFIG=$(bashio::jq "${CONFIG}" ".\"incomplete-dir\"=\"${incomplete_dir}\"")

username=$(bashio::config 'username')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-username\"=\"${username}\"")


password=$(bashio::config 'password')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-password\"=\"${password}\"")

echo "${CONFIG}" > /data/transmission/settings.json
