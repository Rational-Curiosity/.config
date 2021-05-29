import os
keyboard.send_keys("<ctrl>+x")
if store.get_global_value("ctrl-space"):
    store.set_global_value("ctrl-space", False)
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:\n")
