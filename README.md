# WSL2 Setup Scripts

This repository contains two Bash scripts to streamline the setup of a WSL2 Ubuntu 24.04 environment. The scripts automate the installation and configuration of essential tools, CLIs, and customizations for a productive development environment.

---

## Scripts

### 1. `setup-wsl2.sh`

This script installs essential development tools, CLIs, and packages for a new WSL2 environment. It includes HashiCorp tools, AWS CLI, Google Cloud CLI, and more.

#### Features:
- Updates and upgrades system packages.
- Installs the following:
  - **Development tools**: `git`, `curl`, `vim`, `htop`, `zsh`, `tmux`, `jq`, `ansible`, `build-essential`, and `software-properties-common`.
  - **HashiCorp tools**: `nomad`, `vault`, `consul`, and `packer`.
  - **Terraform manager**: Installs and configures `tfenv` for managing Terraform versions.
  - **AWS CLI**: Installs AWS CLI version 2.
  - **Google Cloud CLI**: Installs Google Cloud CLI via the official repository.
- Sets up a custom `.bashrc` with aliases or other configurations if provided in `custom_bashrc`.

#### Usage:
1. Clone this repository:
    ```bash
    git clone <repo-url> && cd setup-wsl2
    ```
2. Run the script:
    ```bash
    bash setup-wsl2.sh
    ```
3. Reload your shell to apply changes:
    ```bash
    source ~/.bashrc
    ```