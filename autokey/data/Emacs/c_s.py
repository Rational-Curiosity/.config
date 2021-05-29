import os
chain = store.get_global_value("emacs-chain-keys")
if chain == ["C-x"]:
    chain.clear()
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:\n")
    keyboard.send_keys("<ctrl>+S")
else:
    keyboard.send_keys("<ctrl>+F")