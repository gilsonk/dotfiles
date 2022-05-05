#!/bin/bash
# Backup and symlink dotfiles
# Need to enable Developer mode for it to work on Windows

OLDIFS="$IFS"
IFS="
"

dotfiles="$HOME/dotfiles"
backups="$HOME/dotfiles.bak/"
config_file="$dotfiles/config.json"
today=$(date '+%Y-%m-%d')

# Why -e?
do_backup="Y"
read -e -p "Back-up previous dotfiles? (Y/n) " do_backup
if [[ "$do_backup" == "N" ]] || [[ "$do_backup" == "n" ]]; then
    do_backup=false
else
    do_backup=true
fi

# Create backup directory
[[ "$do_backup" == "true" ]] && mkdir -p "${backups}/${today}"

config=$(cat "${config_file}" | sed 's#//[^"]*$##g' | tr -d '\r')

[[ $(echo $OSTYPE | grep "linux") ]] && is_unix=true || is_unix=false

[[ "$is_unix" == "true" ]] && os_key="unix" || os_key="dos"

for file in $(echo $config | jq 'keys[]' | tr -d '\r'); do
    echo ""
    source_file="${dotfiles}/$(echo ${file} | tr -d '\"')"

    options=$(
        echo ${config} \
        | jq -r ".${file}.option" \
        | tr -d '\r'
    )
    if [[ "$options" != "null" ]]; then
        echo -e "Which option would you like to choose for ${file}?\n${options}"
        read -e -p "Option number? " choice

        option=$(
            echo ${config} \
            | jq -r ".${file}.\"option\".\"${choice}\"" \
            | tr -d '\r'
        )

        target_file=$(
            echo ${config} \
            | jq ".${file}.\"${os_key}\"" \
            | sed "s/\$option/${option}/g" \
            | envsubst \
            | tr -d '\r' \
            | tr -d '\"'
        )
    else
        target_file=$(
            echo ${config} \
            | jq ".${file}.\"${os_key}\"" \
            | envsubst \
            | tr -d '\r' \
            | tr -d '\"'
        )
    fi

    [[ "$target_file" == "null" ]] && continue

    target_dir=$(dirname ${target_file} | tr -d '\"')

    if [[ "$is_unix" == "true" ]]; then
        sym_cmd="ln -s \"${source_file}\" \"${target_file}\""
    else
        source_file=$(cygpath -w "${source_file}")
        target_file=$(cygpath -w "${target_file}")
        sym_cmd="cmd <<< \"mklink \\\"${target_file}\\\" \\\"${source_file}\\\"\" > /dev/null"
    fi

    if [[ -L "$target_file" ]]; then
        echo "Removing ${file} previous symlink..."
        rm "$target_file"
    elif [[ -e "$target_file" ]]; then
        if [[ "$do_backup" == "true" ]]; then
            echo "Backing ${file} up..."
            dir_name=$(echo ${file%/*} | tr -d '"')
            file_name=$(basename ${target_file})
            mkdir -p "${backups}/${today}/${dir_name}"
            mv "${target_file}" "${backups}/${today}/${dir_name}/${file_name}"
        else
            echo "Removing ${file}..."
            rm "$target_file"
        fi
    fi

    echo -e "Symlink \"${source_file}\" to \"${target_file}...\""
    mkdir -p "$target_dir"
    eval $sym_cmd

    commands=$(
        echo ${config} \
        | jq -r ".${file}.commands" \
        | tr -d '\r'
    )
    [[ "$commands" == "null" ]] && continue

    for file_cmd in $(echo $config | jq -r ".${file}.\"commands\".\"${os_key}\"[]" | tr -d '\r'); do
        echo "Warning: Review command before executing it"
        echo "Do you want to run the following command? It will be passed through eval"
        echo "$file_cmd"
        read -e -p "Run? (N/y) " choice
        if [[ "$choice" == "Y" ]] || [[ "$choice" == "y" ]]; then
            eval $file_cmd
        fi
    done
done

IFS="$OLDIFS"
exit 0

