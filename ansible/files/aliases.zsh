alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias lt='ls -lt'
alias lu='du -sh * | sort -h'

alias vc='python3 -m venv ./.venv'
alias va='source ./.venv/bin/activate'
alias pipf='pip freeze > requirements.txt'
alias pipr='pip install -r requirements.txt'

alias cpv='rsync -ah --info=progress2'

alias docker-compose='podman-compose'
alias dc='docker-compose'
alias dcr='docker-compose run --rm'
alias dce='docker-compose exec'
alias d='docker'
alias k='kubectl'
alias ka='kubectl apply -f'
alias krm='kubectl delete -f'
alias kg='kubectl get'

alias tf='terraform'

# sudo curl -L https://raw.githubusercontent.com/docker/compose/1.28.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
# sudo curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker
complete -F _docker_compose dc
complete -F _docker d
complete -F __start_kubectl k

alias untar='tar -zxvf'
alias wget='wget -c'
alias sha='shasum -a 256'

alias ipe='curl ifconfig.me'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias open="xdg-open"

function getpass() {
    if [ -n "$1" ]; then
        python3 -c "import secrets; print(secrets.token_urlsafe($1))"
    else
        python3 -c "import secrets; print(secrets.token_urlsafe(20))"
    fi
}

function dockershell() {
    docker run --rm -i -t --entrypoint=/bin/bash "$@"
}
function dockershellsh() {
    docker run --rm -i -t --entrypoint=/bin/sh "$@"
}
function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --privileged --entrypoint=/bin/bash -v "${PWD}:/${dirname}" -w "/${dirname}" "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it  --entrypoint=/bin/sh -v "${PWD}:/${dirname}" -w "/${dirname}" "$@"
}

function cd() {
    builtin cd "$@" && ls -lh
}


# stringify wraps all arguments in quotes.
function stringify {
    local input="$@"

    input="${input//\"/\\\"}"
    input="${input//\\/\\\\}"
    input="${input// /+}"

    echo "${input}"
}

# find help on cheat.sh
function help {
    curl "cheat.sh/$(stringify $@)"
}

function remindat() {
    msg="$1"
    shift
    echo "notify-send --urgency=critical '$msg'" | at "$@"
}

function remind {
    if [ "$#" -lt 2 ]; then
        echo 'Examples:'
        echo '    remind "Rest eyes" 30m'
        echo '    remind "Take a break" 2h'
        echo '    remind "Walk the dog" 17:30'
        return 1
    fi
    local msg=$1
    local time=$2

    if [[ "$time" =~ ^([0-9]{2}:?){2}$ ]]; then
        remindat "$msg" "$time"
        return 0
    fi

    if [[ "$time" =~ ^[0-9]+h$ ]]; then
        remindat "$msg" now + ${time%?} hours
        return 0
    fi

    if [[ "$time" =~ ^[0-9]+m$ ]]; then
        remindat "$msg" now + ${time%?} minutes
        return 0
    fi

    if [[ "$time" =~ ^[0-9]+$ ]]; then
        remindat "$msg" now + ${time} minutes
        return 0
    fi

    echo -n "Invalid input. " && remind
}

function uuid() {
    local N B C='89ab'
    for ((N = 0; N < 16; ++N)); do
        B=$(($RANDOM % 256))
        case $N in
        6)
            printf '4%x' $((B % 16))
            ;;
        8)
            printf '%c%x' ${C:$RANDOM%${#C}:1} $((B % 16))
            ;;
        3 | 5 | 7 | 9)
            printf '%02x-' $B
            ;;
        *)
            printf '%02x' $B
            ;;
        esac
    done
    echo
}

function gitignore() {
    URL="https://www.toptal.com/developers/gitignore/api/$(stringify $@)"
    STATUSCODE=$(curl --silent --location --output .gitignore-tmp --write-out "%{http_code}" $URL)

    if test $STATUSCODE -ne 200; then
        echo ".gitignore for '$@' is not available. See more at https://github.com/github/gitignore"
        rm -rf .gitignore-tmp
        return 1
    fi
    cat .gitignore-tmp >>.gitignore
    rm -rf .gitignore-tmp
}

function editorconfig() {
    cat <<EOF >./.editorconfig
# http://editorconfig.org
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{py,rst,ini}]
indent_style = space
indent_size = 4

[*.py]
line_length = 119
multi_line_output = 3
default_section = THIRDPARTY
recursive = true
skip = .venv/
skip_glob = **/migrations/*.py
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true

[*.{html,css,scss,json,js,jsx,yml,md,xml}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
[Makefile]
indent_style = tab
[nginx.conf]
indent_style = space
indent_size = 2
EOF
}

function vscode-python() {
    [[ ! -f ./.venv/bin/activate ]] && python3 -m venv ./.venv
    source ./.venv/bin/activate
    pip install black pylint isort mypy
    gitignore python
    mkdir -p .vscode
    cat <<EOF >./.vscode/settings.json
{
  "files.exclude": {
    "**/.venv": true
  },
  "editor.tabSize": 4,
  "python.formatting.provider": "black",
  "python.linting.flake8Enabled": false,
  "python.linting.mypyEnabled": true,
  "python.linting.pylintEnabled": true,
  "python.linting.enabled": true,
  "[python]": {
    "editor.codeActionsOnSave": {
      "source.organizeImports": true
    }
  },
}
EOF

    [[ ! -f ./pyproject.toml ]] && cat <<EOF >./pyproject.toml
[tool.black]
line-length = 119
target-version = ['py37', 'py38', 'py39']
include = '\.pyi?$'
exclude = '''
/(
  \.toml
  |\.eggs
  |\.sh
  |\.tox
  |\.git
  |\.ini
  |\.pytest_cache
  |\.venv
  |build
  |dist
  |Dockerfile
  |Jenkinfile
  |node_modules
  |migrations
)/
'''

[tool.isort]
profile = 'black'
skip_gitignore = true
skip='migrations'
[tool.coverage]
[tool.coverage.run]
omit = ['tests']
[tool.coverage.report]
show_missing = true
skip_covered = true
exclude_lines = [
'if TYPE_CHECKING:',
'pragma: no cover',
"if __name__ == '__main__':",
]

[mypy]
python_version = '3.9'
allow_redefinition = true
check_untyped_defs = true
show_error_codes = true
warn_unused_ignores = true
strict_optional = true
incremental = true
warn_redundant_casts = true
warn_unused_configs = true
local_partial_types = true
show_traceback = true
exclude = 'migrations/'
strict=true
EOF

    [[ ! -f ./.pylintrc ]] && cat <<EOF >./.pylintrc
[MASTER]
ignore=.git,.venv

[FORMAT]
max-line-length = 119
ignore-long-lines = ^\s*(# )?((<?https?://\S+>?)|(\.\. \w+: .*))$
single-line-if-stmt = no
no-space-check = trailing-comma,dict-separator
max-module-lines = 1000
indent-string = '    '

[MESSAGES CONTROL]
disable =
    C0114, # missing-module-docstring
    C0115, # missing-class-docstring
    C0116, # missing-function-docstring

[BASIC]
docstring-min-length = 5
bad-functions = map,filter,apply,input
bad-names = foo,bar,baz,toto,tutu,tata,tmp,test
good-names = f,i,j,k,db,ex,Run,_,__
module-rgx = (([a-z_][a-z0-9_]*)|([A-Z][a-zA-Z0-9]+))$
const-rgx = (([A-Z_][A-Z0-9_]*)|(__.*__)|log|urlpatterns)$
class-rgx = [A-Z_][a-zA-Z0-9]+$
function-rgx = ([a-z_][a-z0-9_]{2,40}|test_[a-z0-9_]+)$
method-rgx = ([a-z_][a-z0-9_]{2,40}|setUp|set[Uu]pClass|tearDown|tear[Dd]ownClass|assert[A-Z]\w*|maxDiff|test_[a-z0-9_]+)$
attr-rgx = [a-z_][a-z0-9_]{2,30}$
argument-rgx = [a-z_][a-z0-9_]{2,30}$
variable-rgx = [a-z_][a-z0-9_]{2,30}$
class-attribute-rgx = ([A-Za-z_][A-Za-z0-9_]{2,30}|(__.*__))$
inlinevar-rgx = [A-Za-z_][A-Za-z0-9_]*$
no-docstring-rgx=__.*__$|test_.+|setUp$|setUpClass$|tearDown$|tearDownClass$|Meta$
argument-naming-style=snake_case
attr-naming-style=snake_case
class-naming-style=PascalCase
const-naming-style=UPPER_CASE
function-naming-style=snake_case
include-naming-hint=yes
inlinevar-naming-style=snake_case
method-naming-style=snake_case
module-naming-style=snake_case
variable-naming-style=snake_case
[MISCELLANEOUS]
notes = FIXME,XXX,TODO

[SIMILARITIES]
min-similarity-lines = 4
ignore-comments = yes
ignore-docstrings = yes
ignore-imports = no

[CLASSES]
defining-attr-methods = __init__,__new__,setUp
valid-classmethod-first-arg = cls
valid-metaclass-classmethod-first-arg = mcs

[DESIGN]
max-args = 5
ignored-argument-names = _.*
max-locals = 15
max-returns = 6
max-branches = 12
max-statements = 50
max-parents = 7
max-attributes = 7
min-public-methods = 2
max-public-methods = 20
EOF

    [[ ! -f ./.editorconfig ]] && editorconfig

    [[ ! -f ./README.md ]] && cat <<EOF >./README.md
# ${@}

New exiting project!


## References

- [Awesome README](https://github.com/matiassingers/awesome-readme)
EOF

    touch requirements.txt
    [[ ! -f ./local.txt ]] && echo -e "-r requirements.txt\n" >local.txt
    pip freeze | grep -P "black|pylint|isort|mypy" >>local.txt

    [[ ! -f ./.git/HEAD ]] && git init

    which code && code .
}