# bettergit

A Fish script that shortens common git commands and auto generates commit messages for you using `aichat`.

## Installing

`./install.fish`

## Uninstalling

`rm ~/.config/fish/functions/g`

## Using

```fish
g c # git add -A && git commit -m "{GENERATED MESSAGE}"
g co # git checkout
g new # git checkout -b
g s # git status
```
