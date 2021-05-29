if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<left>")
else:
    keyboard.send_key("<left>")