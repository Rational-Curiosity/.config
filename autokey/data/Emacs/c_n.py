if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<down>")
else:
    keyboard.send_key("<down>")