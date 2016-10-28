#!/bin/bash

export PS1='\e[0;36m[\t|\!]\e[m\e[0;33m\u\e[m@\e[0;34m\H\e[m:\e[0;32m\w\e[m \`-:\e[0;31m$?\e[m \n$ '
export CLICOLOR=1
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LSCOLORS=ExFxCxDxBxegedabagacad
export GREP_OPTIONS='--color=always'
export GREP_COLOR="1;37;41"

alias ls='ls -GFh'
