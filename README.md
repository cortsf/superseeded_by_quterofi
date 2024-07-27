# Qutesearch (and qutechange)
These two scripts are roughly the equivalent of `quterofi/switch_engine`. You need qutesearch [(cortsf/qutesearch)](https://github.com/cortsf/qutesearch) available on `$PATH` to use them.

For qutesearch (the program, not the script) to be able to read search engines from your `config.py`, all your engines must be declared like this (just copy the line and replace the alias and url), at the end of the file IIRC. You also have to provide a valid `/home/<user>/..` path on each of these scripts. 

``` python
c.url.searchengines["ddg"] = "https://duckduckgo.com/?q={}&ia=web"
```

It's also possible to use a single file for declaring all the search engines, and then source that file from within `config.py`. This way qutesearch (the program) should be able to read all your search engines.

``` python
config.source('./python/searchengines.py')
```

# Github repos (search engines and quickmarks)
- Replace `path/to/set_gh_quickmark.sh` if you want `gh.alias` quickmarks. This (bash) script should be rewriten in python but I don't use this stuff anymore and I won't do it.
- RESTART AFTER SOURCING ANY CHANGES ON 'github_repos'.

``` python
import subprocess

github_repos=[ # (user, repo, alias)
      ("junegunn", "fzf", "fzf")
    , ("torvalds", "linux", "lnx")
]

for (user, repo, alias) in github_repos:
    c.url.searchengines["gh." + alias] = "https://github.com/search?q=repo%3A" + user + "%2F" + repo + "+{}&type=issues"
    c.url.searchengines["ghi." + alias] = "https://github.com/" + user + "/" + repo + "/issues?q=is%3Aissue+{}"
    c.url.searchengines["ghp." + alias] = "https://github.com/" + user + "/" + repo + "/pulls?q=is%3Aissue+{}"
    subprocess.call("path/to/set_gh_quickmark.sh " + user + " " + " " + repo + " " +alias, shell=True)
```

# Rofi-open
This is a basic bash-only (no extra deps) version of quterofi/open. 

## Usage

``` bash
rofi_open [--string <arg>] [--(no-)newtab] [-h|--help]
```


## Toml syntax
It works with the following toml syntax, exclusively.

``` toml
[[engines]]
alias = "gl"
url = "https://www.google.com/search?q={}"

[[github_repos]]
alias="lnx"
user="torvalds"
repo="linux"
```

## Use without engines.toml

Alternatively, replace the last code block with this one below, to skip looking up for engines declared in engines.toml and asume instead that the last word in the search string is a valid search engine declared as usual in `config.py`, when selecting an engine with `-kb-accept-entry` (any of `"Ctrl+j`,`Ctrl+m`,`Return` or `KP_Enter`)

``` bash
while true; do
    [[ "$it" -lt "6" ]] && it=$((it+1)) || { echo "message-info 'Breaking at: $it'" >> "$QUTE_FIFO"; break; } # use to prevent infinite loops when rofi fails to start (dev/debug only)
    [[ "$ret" == "0" ]] && { echo "$command $(echo "$string" | sed 's/ *$//' | awk 'NF>1{print $NF}') $(echo "$string" | sed 's/ *$//' | sed 's/\ [^\ ]*$//')" >> "$QUTE_FIFO"; break; }
    [[ "$ret" == "1" ]] && exit 0;
    [[ "$ret" == "10" ]] && { echo "$command $string" >> "$QUTE_FIFO"; break; }
    [[ "$ret" == "11" && "$command" == "open" ]] && { command="open -t"; string="$(call_rofi "$string")"; ret="$?"; }
    [[ "$ret" == "11" && "$command" == "open -t" ]] && { command="open"; string="$(call_rofi "$string")"; ret="$?"; }
    [[ "$ret" == "12" ]] && { string="$(call_rofi "$QUTE_URL")"; ret="$?"; }
    [[ "$ret" == "13" ]] && { echo "cmd-set-text -s :$command $string" >> "$QUTE_FIFO" ; break ; }
done
```
