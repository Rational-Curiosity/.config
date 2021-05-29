if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<ctrl>+<shift>+<left>")
else:
    keyboard.send_keys("<ctrl>+<left>")