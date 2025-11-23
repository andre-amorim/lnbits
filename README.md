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
