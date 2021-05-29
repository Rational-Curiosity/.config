import os
chain = store.get_global_value("emacs-chain-keys")
if chain == ["C-c"]:
    chain.clear()
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:\n")
    keyboard.send_keys("<ctrl>+E")
else:
    if store.get_global_value("ctrl-space"):
        keyboard.send_keys("<shift>+<end>")
    else:
        keyboard.send_key("<end>")