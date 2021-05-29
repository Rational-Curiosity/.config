if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<page_up>")
else:
    keyboard.send_key("<page_up>")