# emacs.d

My emacs config

## Setting up on Mac OS X

1. Update emacs to some more recent version: `brew update && brew install emacs` (make sure version is 24.4+)
2. Clone this repo: `git clone https://github.com/alex-fedorov/emacs.d.git ~/.emacs.d`
3. Link your `.emacs.el`: `ln -s ~/.emacs.d/.emacs.el ~/.emacs.el`
4. Re-compile all bytecode: `emacs --batch --eval '(byte-recompile-directory "~/.emacs.d")'`
