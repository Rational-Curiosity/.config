#'^((?!emacs\.Emacs).)*$'
import os
chain = store.get_global_value("emacs-chain-keys")
if isinstance(chain, list):
    chain.append("C-c")
    with open(os.path.expanduser("~/.config/polybar/keys.fifo"), "wb") as f:
        f.write("TITLE:{}\n".format(" ".join(chain)).encode("utf8"))
else:
    store.set_global_value("emacs-chain-keys", ["C-c"])