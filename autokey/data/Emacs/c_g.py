import os
store.set_global_value("ctrl-space", False)
with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
    f.write(b"TITLE:\n")
store.set_global_value("emacs-chain-keys", [])