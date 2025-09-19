# dotfiles

And other stuff to set up a new macOS install.

### macOS

Move `US with umlaut keyboard layout.bundle` to

    /Library/Keyboard\ Layouts/Roman.bundle

then log out and back into your user, then find it in System Preferences under `German`.

From [SO](https://apple.stackexchange.com/questions/466101/removing-language-icon-from-input-fields-after-upgrading-to-macos-sonoma):

    defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

perhaps see also [disable language-switch popup](https://apple.stackexchange.com/a/469076)

### Terminal Theme

    Basic dark.terminal

### VSCode

    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false


### ssh keys

    ~/.ssh/.id_rsa
    ~/.ssh/.id_rsa.pub
