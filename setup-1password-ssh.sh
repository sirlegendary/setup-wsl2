#!/bin/bash
# Script to set up the environment and ensure 1Password SSH agent configuration and ~/.ssh/config

set -o errexit
set -o pipefail
set -o nounset

# Global Variables
AGENT_CONFIG_FILE="$HOME/.config/1Password/ssh/agent.toml"
SSH_CONFIG_FILE="$HOME/.ssh/config"
SSH_KEY_CONFIG='[[ssh-keys]]
vault = "Private"'
SSH_CONFIG_CONTENT='Host *
  IdentityAgent ~/.1password/agent.sock'

# Functions
function ensure_directory_exists() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        printf "Creating directory: %s\n" "$dir_path"
        mkdir -p "$dir_path"
    fi
}

function ensure_agent_config() {
    printf "Ensuring 1Password SSH agent configuration exists...\n"
    ensure_directory_exists "$(dirname "$AGENT_CONFIG_FILE")"

    if [[ ! -f "$AGENT_CONFIG_FILE" ]]; then
        printf "Creating configuration file: %s\n" "$AGENT_CONFIG_FILE"
        printf "%s\n" "$SSH_KEY_CONFIG" > "$AGENT_CONFIG_FILE"
    elif ! grep -qF "$SSH_KEY_CONFIG" "$AGENT_CONFIG_FILE"; then
        printf "Adding missing configuration to %s\n" "$AGENT_CONFIG_FILE"
        printf "\n%s\n" "$SSH_KEY_CONFIG" >> "$AGENT_CONFIG_FILE"
    else
        printf "Configuration already exists in %s\n" "$AGENT_CONFIG_FILE"
    fi
}

function ensure_ssh_config() {
    printf "Ensuring SSH configuration exists...\n"
    ensure_directory_exists "$(dirname "$SSH_CONFIG_FILE")"

    if [[ ! -f "$SSH_CONFIG_FILE" ]]; then
        printf "Creating SSH configuration file: %s\n" "$SSH_CONFIG_FILE"
        printf "%s\n" "$SSH_CONFIG_CONTENT" > "$SSH_CONFIG_FILE"
    elif ! grep -qF "IdentityAgent ~/.1password/agent.sock" "$SSH_CONFIG_FILE"; then
        printf "Adding missing configuration to %s\n" "$SSH_CONFIG_FILE"
        printf "\n%s\n" "$SSH_CONFIG_CONTENT" >> "$SSH_CONFIG_FILE"
    else
        printf "Configuration already exists in %s\n" "$SSH_CONFIG_FILE"
    fi
}

function main() {
    printf "Starting setup for 1Password SSH agent and SSH configuration...\n"
    ensure_agent_config
    ensure_ssh_config
    printf "Setup complete. Get ~/.gitconfig from 1Password and reload your shell to apply changes.\n"
    printf "Run 'ssh-add.exe -l' and 'ssh.exe -T git@github.com' to test.\n"
}

# Execute main function
main
