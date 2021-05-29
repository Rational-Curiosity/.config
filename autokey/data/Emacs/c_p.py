if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<up>")
else:
    keyboard.send_key("<up>")