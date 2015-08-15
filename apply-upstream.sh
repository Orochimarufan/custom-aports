#!/bin/sh
# Imports and applies commits from upstream aports on modified packages
# (c) 2015 Taeyeon Mori

UPSTREAM=".."
UPSTREAM_REMOTE=origin
UPSTREAM_CATEGORIES="main testing"

WORKING_DIR=${TMPDIR-/tmp}/aports-apply-upstream

# Colory
C_PKGNAM=36
C_PKGMSG=33
C_ERRMSG=31
C_PROMPT=33


if [ -e "$WORKING_DIR" ]; then
    echo "Somebody is already running this script which should not be used concurrently."
    echo "If that is not the case, delete $WORKING_DIR and re-run it."
    exit 1
else
    mkdir "$WORKING_DIR"
fi

kbd_int() {
    printf "\n\033[${C_ERRMSG}mKeyboard Interrupt\033[0m\n"
    [ -n "`ls "$WORKING_DIR"`" ] && git am --abort # assume git am was in progress
    rm -r "$WORKING_DIR"
    exit 255
}

trap kbd_int SIGINT


run_in() {
    local _OLDPWD
    local _RT
    _OLDPWD="$OLDPWD"
    cd "$1"
    shift
    "$@"
    _RT=$?
    cd "$OLDPWD"
    OLDPWD="$_OLDPWD"
    return $_RT
}

in_upstream() {
    run_in "$UPSTREAM" "$@"
    return $?
}

yesno() {
    while true; do
        printf "\033[${C_PROMPT}m%s (y/n)\033[0m " "$1"
        read R
        case $R in
            [Yy]*) return 0;;
            [Nn]*) return 1;;
        esac
    done
}


in_upstream git fetch $UPSTREAM_REMOTE

for pkg in `find . -mindepth 1 -maxdepth 1 -type d -not -name '.*'`; do
    pkg="`basename "$pkg"`"

    if ! git ls-files --error-unmatch "$pkg" >/dev/null 2>&1; then
        printf "\033[${C_PKGMSG}mPackage '\033[${C_PKGNAM}m%s\033[${C_PKGMSG}m' is not being tracked!\033[0m\n" $pkg
        continue
    fi

    category=""
    for cat in $UPSTREAM_CATEGORIES; do
        if [ -e "$UPSTREAM/$cat/$pkg" ]; then
            category="$cat"
            break
        fi
    done
    if [ -z "$category" ]; then
        printf "\033[${C_PKGMSG}mPackage '\033[${C_PKGNAM}m%s\033[${C_PKGMSG}m' is not in upstream aports!\033[0m\n" $pkg
        continue
    fi

    printf "\033[${C_PKGMSG}mPackage '\033[${C_PKGNAM}m%s\033[${C_PKGMSG}m' (from %s):\033[0m\n" $pkg $category

    in_upstream git format-patch master...$UPSTREAM_REMOTE -o "$WORKING_DIR" -- "$category/$pkg"

    if [ -z "`ls "$WORKING_DIR"`" ]; then
        echo "No changes."
        continue
    fi

    if yesno "Apply patches?"; then
        git am -p2 --reject "$WORKING_DIR"/*
        APPLY_RESULT=$?
        if [ $APPLY_RESULT -ne 0 ]; then
            echo "NOTE: Dropping into a embedded shell. Use \`resolved\` or \`abort\` to return."
            echo "NOTE: You can use \`edit\` to edit files in vim. It will automatically show any rejected hunks in an additional buffer."
            echo "NOTE: The edited file will be added to the git index after vim is closed. \`ea\` is short for 'edit APKBUILD'."
            echo "NOTE: At this time, the prompt doesn't support history or completion :'("
        fi
        while [ $APPLY_RESULT -ne 0 ]; do
            (
                cd $pkg
                resolved() {
                    exit 2
                }
                abort() {
                    exit 1
                }
                edit() {
                    f=$1
                    shift
                    if [ -e "$f.rej" ]; then
                        vim "$f" -O "$f.rej" "$@"
                    fi
                    git add "$f"
                }
                ea() {
                    edit APKBUILD
                }
                while true; do
                    read -p "(AM) $PWD$ " _cmd
                    eval "$_cmd"
                done
            )
            RT=$?
            if [ $RT -eq 1 ]; then
                git am --abort
                break
            elif [ $RT -eq 2 ]; then
                git am --continue
                APPLY_RESULT=$?
            else
                echo "WARNING: Exit the (AM) prompt with either \`resolved\` or \`abort\`"
            fi
        done
    fi

    rm "$WORKING_DIR"/*
done

if yesno "Pull the changes into local upstream repo?"; then
    in_upstream git pull $UPSTREAM_REMOTE
fi

rmdir "$WORKING_DIR"

