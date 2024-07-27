#!/usr/bin/env bash
#USAGE: set_quickmark <user> <repo> <alias>

cp "$HOME/.config/qutebrowser/quickmarks" "$HOME/.config/qutebrowser/bkp/quickmarks_$(date +"%Y-%m-%d_%T")"

user="$1"
repo="$2"
alias="$3"

if grep -q "^gh\.$alias http.*$" "$HOME/.config/qutebrowser/quickmarks"; then
    sed -i -e "s/^gh\-$alias\ http.*$/gh\-$alias\ https:\/\/github\.com\/$user\/$repo/" "$HOME/.config/qutebrowser/quickmarks"
else
    echo -e "gh.$alias https://github.com/$user/$repo" >> "$HOME/.config/qutebrowser/quickmarks"
fi
