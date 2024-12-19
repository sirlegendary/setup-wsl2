#!/bin/bash
# Script to set up a new WSL2 Ubuntu 24.04 environment with essential packages and tools

set -o errexit
set -o pipefail
set -o nounset

# Global Variables
PACKAGES=(
  "git"
  "curl"
  "wget"
  "unzip"
  "vim"
  "htop"
  "build-essential"
  "software-properties-common"
  "zsh"
  "tmux"
  "python3-pip"
  "jq"
  "ansible"
  "podman"
  "podman-compose"
)
HASHICORP_TOOLS=("nomad" "vault" "consul" "packer" "boundary")
TFENV_DIR="$HOME/.tfenv"
REPO_DIR="$HOME/workspace/setup-wsl2"
BASHRC_CUSTOM="$REPO_DIR/custom_bashrc"
AWS_CLI_INSTALL_SCRIPT="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
GCLOUD_CLI_REPO="https://packages.cloud.google.com/apt"

# Functions
function update_and_upgrade() {
    printf "Updating and upgrading system packages...\n"
    sudo apt update && sudo apt upgrade -y
}

function install_packages() {
    printf "Installing required packages...\n"
    for pkg in "${PACKAGES[@]}"; do
        if ! dpkg -l | grep -qw "$pkg"; then
            printf "Installing %s...\n" "$pkg"
            sudo apt install -y "$pkg"
        else
            printf "%s is already installed, skipping...\n" "$pkg"
        fi
    done
}

function install_hashicorp_tools() {
    printf "Adding HashiCorp GPG key and repository...\n"
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update

    printf "Installing HashiCorp tools...\n"
    for tool in "${HASHICORP_TOOLS[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            printf "Installing %s...\n" "$tool"
            sudo apt install -y "$tool"
        else
            printf "%s is already installed, skipping...\n" "$tool"
        fi
    done
}

function install_tfenv() {
    if [[ ! -d "$TFENV_DIR" ]]; then
        printf "Installing tfenv...\n"
        git clone https://github.com/tfutils/tfenv.git "$TFENV_DIR"
        printf "Adding tfenv to PATH in .bashrc...\n"
        if ! grep -q 'export PATH="$HOME/.tfenv/bin:$PATH"' "$HOME/.bashrc"; then
            printf '\n# tfenv\nexport PATH="$HOME/.tfenv/bin:$PATH"\n' >> "$HOME/.bashrc"
        fi
    else
        printf "tfenv is already installed, skipping...\n"
    fi
}

function install_aws_cli() {
    if ! command -v aws &>/dev/null; then
        printf "Installing AWS CLI...\n"
        local temp_dir
        temp_dir=$(mktemp -d)
        curl -sSL "$AWS_CLI_INSTALL_SCRIPT" -o "$temp_dir/awscliv2.zip"
        unzip "$temp_dir/awscliv2.zip" -d "$temp_dir"
        sudo "$temp_dir/aws/install"
        rm -rf "$temp_dir"
    else
        printf "AWS CLI is already installed, skipping...\n"
    fi
}

function install_gcloud_cli() {
    if ! command -v gcloud &>/dev/null; then
        printf "Installing Google Cloud CLI...\n"
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] $GCLOUD_CLI_REPO cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
        sudo apt update && sudo apt install -y google-cloud-cli
    else
        printf "Google Cloud CLI is already installed, skipping...\n"
    fi
}

function install_podman() {
    if ! command -v podman &>/dev/null; then
        printf "Installing Podman...\n"
        source /etc/os-release
        # Force compatibility with Ubuntu 22.04 repository
        echo "deb [signed-by=/usr/share/keyrings/podman-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Ubuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/podman.list
        curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Ubuntu_22.04/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/podman-archive-keyring.gpg
        sudo apt update && sudo apt install -y podman
    else
        printf "Podman is already installed, skipping...\n"
    fi
}

function setup_bashrc() {
    printf "Setting up custom .bashrc configurations...\n"
    if [[ -f "$BASHRC_CUSTOM" ]]; then
        if ! grep -q "# Custom Aliases" "$HOME/.bashrc"; then
            cat "$BASHRC_CUSTOM" >> "$HOME/.bashrc"
            printf "Custom aliases appended to .bashrc\n"
        else
            printf "Custom aliases already present in .bashrc\n"
        fi
    else
        printf "Error: %s not found. Skipping custom bashrc setup.\n" "$BASHRC_CUSTOM" >&2
        return 1
    fi
}

function main() {
    printf "Starting full WSL2 setup...\n"

    update_and_upgrade
    install_packages
    install_hashicorp_tools
    install_tfenv
    install_aws_cli
    install_gcloud_cli
    # install_podman

    printf "Setting up custom bashrc...\n"
    setup_bashrc

    printf "Setup complete. Reload your shell to apply changes.\n"

}


if [[ $# -eq 1 && $(declare -F "$1") ]]; then
    printf "Running function: %s\n" "$1"
    "$1"
else
    main
fi
