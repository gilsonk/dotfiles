# dotfiles
This repository contains my public configuration files for several applications, both on Unix and Dos systems.

## Applications
Currently, the following applications settings are handled by this repo:
+ bash
+ vim
+ VS Code (Microsoft build, Source Build, or VS Codium)
+ tmux

## Usage
### Set up the config.json file
Each application files are configured from within the _config.json_ file. This file follow a specific structure:
+ fileName: each file from within the dotfiles folder act as a JSON key within the config file.
The following keys are
+ unix / dos: path where to symlink fileName, respectively on Unix and Dos systems.
+ option: dictionnary of possible options, can be used as a variable within the paths (e.g. VS Code has different path depending on its build)
+ commands (unix / dos): dictionnary of lists of commands to be executed (e.g. to install Vim Plug)

Example:

```json
{
    "file_one": {
        "unix": "$HOME/.file_one",
        "dos": "$APPDATA/_file_one"
    }
    "file_two" {
        "option": {
            "1": "App_V1",
            "2": "App_V2"
        },
        "unix": "$HOME/.config/$option/file_two",
        "dos": "$HOME/$option/file_two"
    }
    "file_three": {
        "unix": "$HOME/file_three",
        "dos": "$HOME/file_three",
        "commands": {
            "unix": [
                "mkdir this_folder",
                "git clone repo"
            ],
            "dos": [
                "mkdir this_folder",
                "git clone repo"
            ]
        }
    }
}
```

### Install symlinks
From within a bash prompt (Unix, or Git Bash), run the following commands, then follow the instructions

```shell
cd dotfiles/
chmod +x bootstrap.sh
./bootstrap.sh
```

**Warning**: If your config file contains _commands_ parameters, this script will evaluate them.
Carefully review them before allowing the script to run it.

### (Optional) Windows configuration
If you are using Windows 10, symlinks only works
+ If you are running as administrator
+ If you have Developer mode enable

I would not recommand running this script as an admin.
To enable Developer mode, you can follow the [official instructions of Microsoft](https://docs.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development).

