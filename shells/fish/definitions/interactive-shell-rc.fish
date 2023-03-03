# Initialization code sourced at every interactive fish shell (usually on terminals).

# Disable the greeting.
set fish_greeting ""

# Remap the bindings for the fzf fish plugin.
if type -q fzf_configure_bindings
    fzf_configure_bindings --history=\e\ch --variables=\e\cv
end
