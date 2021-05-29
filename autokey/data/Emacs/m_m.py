if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<home>")
else:
    keyboard.send_key("<home>")