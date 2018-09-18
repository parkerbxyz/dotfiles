# https://github.com/aamnah/tldrdevnotes.com/blob/master/_workflow/setup-new-macos-machine-homebrew-cask.md

installCLT() {
	# Install Command Line Tools (CLT) for Xcode
	echo -e "/n Installing Command Line Tools (CLT) for Xcode"
	sudo xcode-select --install
}

installHomebrew() {
	echo -e "/n Installing Homebrew"

	# install Homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	# update perms on /usr/local/ to avoid: Warning: /usr/local is not writable, sudo is needed
	sudo chown -R $USER /usr/local/
	# add /usr/local/bin (the path where Cellar is) to your $PATH
	export $PATH=/usr/local/bin:$PATH

	brew update
}

installKegs() {
	# List all your Kegs/Formulae/Taps here
	# These will be installed in: /usr/local/Cellar/

	echo -e "/n Installing Kegs (Command Line Utilities)"
	# Programming
	brew install node mongodb sqlite

	# Tools
	brew install wget tree coreutils

	# Install tab-completion for brew casks
	brew install brew-cask-completion
}

installCasks() {
	# List all your Casks here
	# These will be installed in: /usr/local/Caskroom/
	# More: https://github.com/caskroom/homebrew-cask/tree/master/Casks

	echo -e "/n Installing Casks (GUI Software)"
	# Browsers
	brew cask install google-chrome opera

	# Code Editors
	brew cask install visual-studio-code sublime-text brackets

	# Graphics
	brew cask install sketch

	# Tools
	brew cask install alfred appcleaner caffeine dash discord evernote filezilla gitkraken gitter iterm2 postman shuttle skype teamviewer the-unarchiver vlc webtorrent
}

installCLT
installHomebrew
installKegs
installCasks

echo -e "/n DONE!"
