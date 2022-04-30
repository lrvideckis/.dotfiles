import os
from typing import List

# usage: python3 push_to_master_and_merge.py

# in response to asking user [Y/n]: only these inputs are a yes: "", "y", "Y"
# default is yes so I can enter-through this script quickly
def isYes(user_input: str) -> bool:
    return user_input == "" or user_input.lower() == "y"

# copied over alias from zsh, as aliases don't work inside python scripts
CONFIG = "/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "

# every command run in this script is prefixes by "config"
# this function prints a command, asks user for confirmation, and then runs command
def printAndRunCommand(commands: List[str]) -> None:
    print()
    for command in commands:
        print("$ config " + command)
    if isYes(input("run these command(s)? [Y/n] ")):
        for command in commands:
            os.system(CONFIG + command)

print("Intended use: pushing only files shared across my machines (so on master branch)")

initial_branch = os.popen(CONFIG + " branch --show-current").read()[:-1]
os.system(CONFIG + "branch")


# some configs are shared among my machines (.vimrc, .zshrc, etc)
# the steps to push changes to these files goes roughly like this:
#    1) checkout master
#    2) add, commit, push to master
#    3) re-checkout machine-branch
#    4) merge master into branch and push
# it was getting really repetitive, hence this script

printAndRunCommand(["checkout master", "branch"])
printAndRunCommand(["add -u", "status"])
if isYes(input("Do a commit? [Y/n] ")):
    commit_message = input("Enter a commit message: ")
    # entering an empty commit message breaks the script.
    # So if I want to just enter-through this script very fast it will still work
    if commit_message == "":
        commit_message = "default commit message"
    printAndRunCommand(["commit -m \"" + commit_message + "\""])
printAndRunCommand(["pull"])
printAndRunCommand(["push"])
printAndRunCommand(["checkout " + initial_branch + " -f", "branch"])
printAndRunCommand(["merge master"])
printAndRunCommand(["pull"])
printAndRunCommand(["push"])
