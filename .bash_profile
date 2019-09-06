# .bash_profile

# Get the aliases and functions
if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

# bitrix_entry_point
/opt/bitrix_entrypoint.sh
