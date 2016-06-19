#!/usr/bin/env bash
#
# set up git and ssh

local title=git
local pub=${CONFIG__sshkey:-"$HOME/.ssh/id_rsa.pub"}

copy_ssh () {
    continue_when_ready "Type ${CYAN}<ready>${END_COLOR} to continue:" 'ready'
    log 'Completed SSH key setup.' success
}

setup_ssh () {
    local response
    # create new key
    log 'Creating new SSH key... '
    [[ -z $CONFIG__git_useremail ]] && ask "What is your git user email?" input_email | CONFIG__git_useremail=$input_email

    ssh-keygen -t rsa -b 4096 -C "${CONFIG__git_useremail}" -f $pub
    eval "$(ssh-agent -s)"
    ssh-add "$pub"
    cat $pub | pbcopy

    log "${GREEN}A new SSH key was created and copied to your clipboard.${END_COLOR} " success
    open 'https://github.com/account/ssh'
    log "Paste the new key into your GitHub account...\n${LOG_INDENT}      (${MAGENTA}https://github.com/account/ssh${END_COLOR})"
    copy_ssh
}

setup_gitconfig () {
    # set up gitconfig
    log 'Setting up gitconfig...'

    git_credential='cache'
    [[ "$(uname -s)" == 'Darwin' ]] && git_credential='osxkeychain'

    [[ -z $CONFIG__git_username ]] && ask "What is your git user name?" input_username && CONFIG__git_username=input_username
    [[ -z $CONFIG__git_useremail ]] && ask "What is your git user email?" input_email && CONFIG__git_useremail=input_email

    if [[ -z $CONFIG__git_username ]] || [[ -z $CONFIG__git_useremail ]]; then
        log '(user choice) gitconfig was skipped because git user name or email was no configured.' fail
    else
        cat "$OSZ_ROOT/git/gitconfig.local" | sed -e "s/AUTHORNAME/$CONFIG__git_username/g" -e "s/AUTHOREMAIL/$CONFIG__git_useremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" > "$HOME/.gitconfig.local"
        log 'Completed gitconfig setup.' success
    fi
}

# should we run ssh?
log 'Setting up SSH... ' info $title ' '
if [[ -f $pub ]]; then
    echo 'ALREADY EXISTS.'
    can_overwrite 'An SSH key already exists. Overwrite it with a new one?' 'Skipped SSH setup' && rm -r $pub && setup_ssh
else
    echo ''
    can_continue 'Create a new SSH key?' 'Skipped SSH setup' && setup_ssh
fi

# should we run gitconfig?
log 'Running gitconfig...' ' '
if [[ ! -f "$OSZ_ROOT/git/gitconfig.local" ]]; then
    # skip if no gitconfig.local found
    log "gitconfig setup was skipped because ${MAGENTA}${OSZ_ROOT}/git/gitconfig.local${END_COLOR} does not exist." fail
elif [[ -f "$HOME/.gitconfig.local" ]]; then
    # what to do if ~/.gitconfig.local already exists?
    can_overwrite "${MAGENTA}~/.gitconfig.local${YELLOW} already exists. Update it?" 'Skipped gitconfig' && setup_gitconfig
else
    can_continue 'Set up a new gitconfig?' 'Skipped gitconfig' && setup_gitconfig
fi
