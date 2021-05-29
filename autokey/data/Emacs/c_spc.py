import os

chain = store.get_global_value("emacs-chain-keys")
if isinstance(chain, list):
    chain.clear()
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:\n")

if store.get_global_value("ctrl-space"):
    store.set_global_value("ctrl-space", False)
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:\n")
#    try:
#        f = os.open(os.path.expanduser("~/.config/polybar/keys.fifo"), os.O_WRONLY | os.O_NONBLOCK)
#    except OSError:
#        pass
#    else:
#        try:
#            os.write(f, b"TITLE:SHIFT")
#        finally:
#            os.close(f)
else:
    store.set_global_value("ctrl-space", True)
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write(b"TITLE:SHIFT\n")
#    try:
#        f = os.open(os.path.expanduser("~/.config/polybar/keys.fifo"), os.O_WRONLY | os.O_NONBLOCK)
#    except OSError:
#        pass
#    else:
#        try:
#            os.write(f, b"TITLE:SHIFT")
#        finally:
#            os.close(f)