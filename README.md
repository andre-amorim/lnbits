# LNBits Development Environment

This project is set up to practice getting the LNBits project up and running on this VM using `uv`.

## Project Objective

The primary goal is to follow the `uv` installation guide for LNBits to run a local instance for development and testing purposes.

Reference: [LNBits Installation Guide (UV)](https://github.com/lnbits/lnbits/blob/dev/docs/guide/installation.md#option-2-uv-recommended-for-developers)

## Workflow / Plan

### A Note on Git Usage

You've correctly identified that pushing directly to the main `lnbits` repository should be avoided to prevent polluting the upstream project. The best practice for this scenario isn't just to be careful, but to use GitHub's features to prevent mistakes and manage your own changes effectively.

**The recommended best practice is to fork the repository.**

Forking creates a personal copy of the `lnbits` repository under your own GitHub account. This gives you a personal remote server (like your proposed `lab-test` repository) where you can save your own commits and experiments without any risk of interfering with the original project.

The modified workflow should be:

1.  **Fork the LNBits repository:**
    *   Go to `https://github.com/lnbits/lnbits` and click the "Fork" button.

2.  **Clone your personal fork:**
    ```bash
    # Replace <YourUsername> with your actual GitHub username
    git clone https://github.com/<YourUsername>/lnbits.git
    ```
    This ensures that when you `git push`, you are pushing to your personal copy, not the original.

3.  **Navigate into the project directory:**
    ```bash
    cd lnbits
    ```

4.  **Create and activate a virtual environment:**
    ```bash
    uv venv
    source .venv/bin/activate
    ```

5.  **Install dependencies:**
    ```bash
    uv pip install -r requirements.txt
    ```

This approach is standard practice. It allows you to freely push your work to your own fork while still being able to pull updates from the original "upstream" repository if needed.

## Lessons Learned: Reproducing the Environment

Getting the LNBits environment running smoothly required understanding the Nix-based setup provided by the project. Here are the key takeaways for future reference:

### 1. Trust the `flake.nix`

The project's `flake.nix` is the source of truth for the development environment. It uses `uv2nix` to create a reproducible Python environment with all dependencies pre-packaged. Manual installation attempts using `uv sync` are prone to failure due to missing system-level build tools and complex dependency conflicts (like the `cffi` version mismatch we encountered).

### 2. The Golden Command

The simplest and most reliable way to start the application is to let Nix handle everything. By running the following command from within the `lnbits` directory, Nix will automatically build the environment defined in `flake.nix` and run the default application:

```bash
nix run
```

This command takes care of installing all necessary build tools and Python packages in an isolated environment, bypassing the system's configuration and avoiding cache conflicts.

### 3. Configuring the IDX Environment

To ensure a seamless experience within the IDE, the `.idx/dev.nix` file should be configured to include the necessary build tools. This makes them available in the terminal for any manual build or debugging tasks. Adding the following packages to your `dev.nix` prevents build failures if you need to re-build dependencies from scratch:

```nix
{ pkgs, ... }: {
  # Add the necessary build tools to the environment
  packages = [
    pkgs.automake
    pkgs.autoconf
    pkgs.libtool
    pkgs.pkg-config
  ];
}
```

By following these principles, reproducing the LNBits development environment in a new VM becomes a straightforward and error-free process.

## Enforcing Git Configuration on Startup

To ensure your git remotes are always configured correctly when you start your VM, you can create a startup script. This script will automatically set up your forked `lnbits` repository as the `origin` and the original `lnbits` repository as `upstream`.

### 1. Create the Startup Script

Create a file named `configure_git.sh` in the root of your project with the following content:

```bash
#!/bin/bash
cd lnbits
# Check if the upstream remote is already configured
if ! git remote -v | grep -q "upstream"; then
    git remote rename origin upstream
fi
# Check if the origin remote is your fork
if ! git remote -v | grep -q "andre-amorim/lnbits"; then
    git remote add origin https://github.com/andre-amorim/lnbits.git
fi
git remote set-url origin https://github.com/andre-amorim/lnbits.git
git fetch origin
```

### 2. Make the Script Executable

Open your terminal and run the following command to make the script executable:

```bash
chmod +x configure_git.sh
```

### 3. Running the Script on Startup

Since your VM environment does not seem to use `systemd` or `cron`, the best way to run this script is to add it to your shell's startup file (e.g., `.bashrc`, `.zshrc`). Add the following line to the end of your shell's startup file:

```bash
/path/to/your/project/configure_git.sh
```

Replace `/path/to/your/project/` with the absolute path to your project's root directory. This will ensure that your git remotes are correctly configured every time you open a new terminal.
