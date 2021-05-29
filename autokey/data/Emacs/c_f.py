if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<right>")
else:
    keyboard.send_key("<right>")