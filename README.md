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
  - **HashiCorp tools**: `nomad`, `vault`, `consul`, `boundary` and `packer`.
  - **Terraform manager**: Installs and configures `tfenv` for managing Terraform versions.
  - **AWS CLI**: Installs AWS CLI version 2.
  - **Google Cloud CLI**: Installs Google Cloud CLI via the official repository.
- Sets up a custom `.bashrc` with aliases or other configurations if provided in `custom_bashrc`.

#### Usage:
1. Clone this repository:
    ```bash
    git clone https://github.com/sirlegendary/setup-wsl2.git && cd setup-wsl2
    ```
2. Run the script:
    ```bash
    bash setup-wsl2.sh
    ```
    - Run only for a specific function:
        ```bash
        bash setup-wsl2.sh install_packages
        ```
3. Reload your shell to apply changes:
    ```bash
    source ~/.bashrc
    ```

### 2. `setup-1password-ssh.sh`

This script configures 1Password SSH integration and updates the SSH client configuration.

#### Features:
- Creates the `~/.config/1Password/ssh/agent.toml` file (if it doesn’t exist).
- Ensures the file contains the following configuration:
    ```toml
    [[ssh-keys]]
    vault = "Private"
    ```
- Configures the SSH client by creating or updating the ~/.ssh/config file with the following content:
    ```
    Host *
        IdentityAgent ~/.1password/agent.sock
    ```

#### Usage:

1. Clone this repository:
    ```bash
    git clone https://github.com/sirlegendary/setup-wsl2.git && cd setup-wsl2
    ```
2. Run the script:
    ```bash
    bash setup-1password-ssh.sh
    ```

### Customization
For `setup-wsl2.sh`, you can add custom aliases or configurations by placing them in a file named `custom_bashrc` in the repository root. Example:
```bash
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'
```
The script will append the contents of this file to your `~/.bashrc` during execution.