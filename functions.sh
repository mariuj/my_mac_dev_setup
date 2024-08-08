#!/bin/bash

install_homebrew() {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  [ $? -eq 0 ] && echo "Homebrew installed." || { echo "Homebrew install failed."; exit 1; }
}

brew_install() {
  echo "Installing packages from Brewfile..."
  brew bundle --file=Brewfile
  [ $? -eq 0 ] && echo "Brew packages installed." || { echo "Brew packages install failed."; exit 1; }
}

pipx_install() {
  export PATH=$PATH:~/.local/bin
  pipx ensurepath
  pipx install mypy --include-deps
  pipx install ruff --include-deps
  pipx install isort --include-deps
  pipx install pyright --include-deps
  pipx install jupyterlab --include_deps
  echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc

  [ $? -eq 0 ] && echo "pipx packages instaled." || { echo "pipx packages install failed."; exit 1; }
}

generate_ssh_key() {
  local ssh_key_path="${HOME}/.ssh/id_rsa"
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N ""
  [ $? -eq 0 ] && echo "SSH key generated." || { echo "SSH key generation failed."; exit 1; }
  echo "Add this SSH key to GitHub: $(cat "${ssh_key_path}.pub")"
  echo "Visit: https://github.com/settings/ssh/new"
  read -p "Press Enter after adding the SSH key to GitHub..."
}

setup_iterm2_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  curl -o ~/Downloads/iterm2-night-owl.zip https://github.com/nickcernis/iterm2-night-owl/archive/master.zip
  unzip ~/Downloads/iterm2-night-owl.zip -d ~/Downloads/iterm2-night-owl && rm ~/Downloads/iterm2-night-owl.zip
  open ~/Downloads
  echo "1. Open iTerm2, go to Preferences -> Profiles -> Colors"
  echo "2. Import the Night Owl.itermcolors file from ~/Downloads/iterm2-night-owl"
  echo "3. Set Night Owl as the color preset"
  read -p "Press Enter after setting the color preset..."
  rm -rf ~/Downloads/iterm2-night-owl

  [ $? -eq 0 ] && echo "iTerm2 and Zsh setup complete." || { echo "iTerm2 and Zsh setup failed."; exit 1; }
}

setup_pyenv() {
  pyenv install 3.12
  pyenv virtualenv 3.12 default_env
  pyenv global default_env

  echo 'if command -v pyenv 1>/dev/null 2>&1; then' >> ~/.zshrc
  echo '  eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'fi' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

  [ $? -eq 0 ] && echo "pyenv setup complete." || { echo "pyenv setup failed."; exit 1; }
}

setup_vim() {
  # Copy / paste the rc file
  local script_dir=$(dirname "$0")
  local vimrc_path="${HOME}/.vimrc"
  local repo_vimrc="${script_dir}/vimrc"
  echo "Setting up Vim..."
  [ -f "$vimrc_path" ] && mv "$vimrc_path" "${vimrc_path}.bak"
  if [ -f "$repo_vimrc" ]; then
    cp "$repo_vimrc" "$vimrc_path"
    [ $? -eq 0 ] && echo "Vim configuration copied." || { echo "Vim configuration copy failed."; exit 1; }
  else
    echo "Vim configuration file from repo not found."
    exit 1
  fi

  # Install vim plug
  if [ ! -f "${HOME}/.vim/autoload/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  fi

  # Install all the plugins from the rc
  echo "Installing Vim plugins..."
  vim +PlugInstall +qall
  [ $? -eq 0 ] && echo "Vim setup complete." || { echo "Vim setup failed."; exit 1; }
}

setup_aerospace() {
  cp aerospace.toml ~/.aerospace.toml
  [ $? -eq 0 ] && echo "Aerospace setup complete." || { echo "Aerospace setup failed."; exit 1; }
}

setup_jupyter() {
  echo "Setting up Jupyter Lab..."
  # Installing JupyterLab extensions
  pipx inject jupyterlab jupyterlab-git
  jupyter labextension install @jupyterlab/git

  pipx inject jupyterlab jupyterlab-toc
  jupyter labextension install @jupyterlab/toc

  pipx inject jupyterlab jupyterlab-latex
  jupyter labextension install @jupyterlab/latex

  pipx inject jupyterlab jupyterlab-drawio
  jupyter labextension install jupyterlab-drawio

  pipx inject jupyterlab jupyterlab-execute-time
  jupyter labextension install jupyterlab-execute-time

  pipx inject jupyterlab jupyterlab-variableInspector
  jupyter labextension install @lckr/jupyterlab_variableinspector

  pipx inject jupyterlab jupyterlab-spreadsheet
  jupyter labextension install jupyterlab-spreadsheet

  # JupyterLab Code Formatter
  jupyter labextension install @jupyterlab/toc
  jupyter labextension install @jupyterlab-contrib/jupyterlab_code_formatter
  pipx inject jupyterlab jupyterlab_code_formatter
  jupyter serverextension enable --py jupyterlab_code_formatter

  mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/code-formatter
  cat <<EOT > ~/.jupyter/lab/user-settings/@jupyterlab/code-formatter/settings.jupyterlab-settings
{
  "preferences": {
    "default_formatter": {
      "python": ["isort", "ruff"]
    },
    "formatOnSave": true
  }
}
EOT

  [ $? -eq 0 ] && echo "Jupyter Lab setup complete." || { echo "Jupyter Lab setup failed."; exit 1; }
}

setup_github() {
  echo "Setting up GitHub..."
  read -p "Enter your GitHub email: " email
  read -p "Enter your GitHub name: " name
  git config --global user.email "$email"
  git config --global user.name "$name"
  git config --global init.defaultBranch main
  git config --global credential.helper osxkeychain
  [ $? -eq 0 ] && echo "GitHub setup complete." || { echo "GitHub setup failed."; exit 1; }
}

setup_aliases() {
  local script_dir=$(dirname "$0")
  while IFS= read -r alias; do
    echo "$alias" >> ~/.zshrc
  done < "$script_dir/zsh_aliases.txt"
  [ $? -eq 0 ] && echo "Aliases added to .zshrc." || { echo "Failed to add aliases to .zshrc."; exit 1; }
}

setup_plugins() {
  local script_dir=$(dirname "$0")
  while IFS= read -r plugin; do
    eval "$plugin"
  done < "$script_dir/zsh_plugins.txt"

  [ $? -eq 0 ] && echo "Plugins and themes added to .zshrc." || { echo "Failed to add plugins and themes to .zshrc."; exit 1; }
}

final_steps() {
  chsh -s "$(which zsh)"
}
