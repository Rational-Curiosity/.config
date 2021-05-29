if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<ctrl>+<shift>+<right>")
else:
    keyboard.send_keys("<ctrl>+<right>")